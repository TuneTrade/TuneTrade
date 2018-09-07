pragma solidity 0.4.24;

import "./PausableToken.sol";


contract TXTToken is PausableToken {

using SafeMath for uint256;


string public name;
string public symbol;
uint8 public decimals;

// 200 millions tokens are vested. Every 150 days (5 months)  tokens release 50 millions
address private foundersWallet;
uint256 private tokenStartTime;
uint256 private constant  phasePeriod  = 30 days;
uint256 private constant phaseTokens  = 20 * 10 ** 24;
uint256 private lastPhase = 0;

event TokensReleased(uint256 amount, address to, uint256 phase);
///@notice Constructor set total supply and set owner of this contract as _fondersWallet. Founders wallet also receives 50 millions tokens.

constructor (address _foundersWallet) public{
  require(_foundersWallet != address(0x0));
  name = "Tune Trade Token";
  symbol = "TXT";
  decimals = 18;
  foundersWallet = _foundersWallet;
  totalSupply_ = 500 * 10 ** 24;
  balances[foundersWallet] = 30 * 10 ** 24;
  balances[owner] = 250 * 10 **24; //owner gets 250 000 000 tokens to transfer to crowdsale.
  transferOwnership(foundersWallet);
  tokenStartTime = now;
  releaseTokens();
}


function _phasesToRelease() internal view returns (uint256)
{
  if (lastPhase == 11) return 0;
  uint256 timeFromStart = now.sub(tokenStartTime);
  uint256 phases = timeFromStart.div(phasePeriod).add(1);
  if (phases > 11) phases = 11;
  return phases.sub(lastPhase);
}

function _readyToRelease() internal view returns(bool) {

  if(_phasesToRelease()> 0) return true;
   return false;

}

function releaseTokens () public returns(bool) {

  require(_readyToRelease());
  uint256 toRelease = _phasesToRelease();

  balances[foundersWallet] = balances[foundersWallet].add(phaseTokens.mul(toRelease));
  lastPhase = lastPhase.add(toRelease);
  emit TokensReleased(phaseTokens*toRelease,foundersWallet,lastPhase);

  return true;
}

function transfer(address _to, uint256 _value) public returns (bool)
{
  if(msg.sender == foundersWallet) {
    if(_readyToRelease()) releaseTokens();
  }
  return super.transfer(_to,_value);

}

function balanceOf(address _owner) public view returns (uint256) {
  if(_owner == foundersWallet)
  {
    return balances[_owner].add( _phasesToRelease().mul(phaseTokens));
  }
  else {
  return balances[_owner];
  }

}

}
