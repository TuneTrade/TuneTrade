pragma solidity ^0.4.24;

import "./PausableToken.sol";
import "./DetailedERC20.sol";


contract TXTToken is PausableToken, DetailedERC20 {

using SafeMath for uint256;
using SafeMath for uint;



// 200 millions tokens are vested. Every 150 days (5 months)  tokens release 50 millions
address private foundersWallet;
uint256 private tokenStartTime;
uint256 private constant  phasePeriod  = 30 days;
uint256 private constant phaseTokens  = 10 * 10 ** 24;
uint256 private lastPhase = 0;

event TokensReleased(uint256 amount, address to, uint256 phase);
///@notice Constructor set total supply and set owner of this contract as _fondersWallet. Founders wallet also receives 50 millions tokens.

constructor (address _foundersWallet) public DetailedERC20("Tune Trade Token","TXT",18)  {
  require(_foundersWallet != address(0x0));
  foundersWallet = _foundersWallet;
  totalSupply_ = 500 * 10 ** 24;
  balances[foundersWallet] = 0;
  balances[owner] = 250 * 10 **24; //owner gets 250 000 000 tokens to transfer to crowdsale.
  transferOwnership(foundersWallet);
  tokenStartTime = now;
  releaseTokens();
}


function _phasesToRelease() internal view returns (uint)
{
  if (lastPhase == 10) return 0;
  uint256 timeFromStart = now.sub(tokenStartTime);
  uint256 phases = timeFromStart/(phasePeriod) + 1;
  if (phases > 10) phases = 10;
  return phases - lastPhase;
}

function _readyToRelease() internal view returns(bool) {

  if(_phasesToRelease()> 0) return true;
   return false;

}

function releaseTokens () public returns(bool) {

  require(_readyToRelease());
  uint256 toRelease = _phasesToRelease();

  balances[foundersWallet] = balances[foundersWallet].add(phaseTokens * toRelease);
  lastPhase = lastPhase.add(toRelease);
  emit TokensReleased(phaseTokens*toRelease,foundersWallet,lastPhase);

  return true;
}

function transfer(address _to, uint256 _value) public returns (bool)
{
  if(msg.sender == foundersWallet) {
    if(_readyToRelease()) releaseTokens();
  }
  super.transfer(_to,_value);
}

function balanceOf(address _owner) public view returns (uint256) {
  if(_owner == foundersWallet)
  {
    return balances[_owner] + _phasesToRelease() * phaseTokens;
  }
  else {
  return balances[_owner];
  }

}

}
