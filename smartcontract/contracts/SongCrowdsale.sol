pragma solidity ^0.4.24;
/* pragma experimental ABIEncoderV2; */


import "./StandardToken.sol";
import "./Crowdsale.sol";
import "./Ownable.sol";

/// @author         Robert Magier
/// @title          SongCrowdSale
/// @notice         This is Song ICO sale contract based on Open Zeppelin Crowdsale contract.
///                 It's purpose is to sell song tokens in main sale and presale.

contract SongCrowdSale is Crowdsale, Ownable
{
  enum State {PreSale,Campaign,Ended,Refund,Closed}
  /// @param teamTokens number of tokens reserved for a team. It is not possible to sell them.
  uint256 public teamTokens;
   /// @param minPreSale minimum amount of tokens sold in presale. If not sold then it is not possible to go to main
   /// sale.
  uint256 public minPreSaleETH;
  /// @param minimum number of tokens which have to be sold in MainSale so it is successfull. If not then contributors
  /// are allowed to have a refund.
  uint256 public minMainSaleETH;
  /// @param maximum Ether contribution. Sale contract can't sell tokens for more than this number.
  uint256 maxEth;
  /// @param maxCap maximum number of tokens which can be sold.
  uint256 maxCap;
  ///@param minCap minimum number of tokens which have to be sold or sale will be cancelled.
  uint256 minCap;
  /// @param durationDays main sale campaign duration in days
  uint256 durationDays;
  /// @param preSaleDays - presale capaign duration in days
  uint256 preSaleDays;

  uint256 preSaleEnd;
  uint256 saleEnd;


  uint256 bonusPresalePeriod;
  uint256 firstPeriod;
  uint256 secondPeriod;
  uint256 thirdPeriod;

  uint256 bonusPreSaleValue;
  uint256 bonusFirstValue;
  uint256 bonusSecondValue;
  uint256 bonusThirdValue;


  // 0 - presale 1 - first period 2-second period 3 - third period
  uint256 volume;
  uint256 phase=1;

  uint saleStart;

  bool refundAvailable = false;
  bool closed = false;
  bool isRefundable = false;

  mapping (address=>uint256) collectedFunds;

  bool debug = true;
  uint256 testNow = 0;


function DefineBonusValues(uint8 value1, uint8 value2, uint8 value3, uint8 value4) internal  returns (bool)
{

 bonusPreSaleValue = value1;
 bonusFirstValue = value2;
 bonusSecondValue = value3;
 bonusThirdValue = value4;

 return true;
}

function DefineBonusPeriods(uint8 period1,uint8 period2,  uint8 period3, uint8 period4) internal  returns (bool)
{

  bonusPresalePeriod = period1;
  firstPeriod = period2;
  secondPeriod = period3;
  thirdPeriod = period4;

  return true;
}


///@notice Return bonus value for current moment in %. If sale is already out of bonus period it will return 0.
///@dev It will fail if for any reason now is smaller than saleStart
function currentBonusValue() internal returns (uint256)
{
    if (_campaignState() == State.PreSale) {
      if (_now() <= (saleStart + (bonusPresalePeriod * 24 * 60 * 60))) {
        return bonusPreSaleValue;
      }
      return 0;

    }
    if(_campaignState() == State.Campaign) {
      if (_now() > ((preSaleEnd + (firstPeriod + secondPeriod + thirdPeriod) * 24 * 3600 ))) return 0;
      if (_now() > ((preSaleEnd + (firstPeriod + secondPeriod) * 24 * 3600 ))) return bonusThirdValue;
      if (_now() > ((preSaleEnd + (firstPeriod) * 24 * 3600 ))) return bonusSecondValue;
      if (_now() > (preSaleEnd)) return bonusFirstValue;
      return 0;
    }
    return 0;

}

function _campaignState() internal view returns (State _state)
{
  /* enum State {PreSale,Campaign,Ended, Refund} */
  if (refundAvailable) return State.Refund;
  if (closed) return State.Closed;
  if (_now() <= preSaleEnd) return State.PreSale;
  if (_now() > preSaleEnd && _now() <= saleEnd)
  {
    if(weiRaised < minPreSaleETH) return State.Refund;
    else return State.Campaign;
  }
  if (weiRaised < minMainSaleETH) return State.Refund;

  if (minCap > 0 ) {
    if(volume < minCap && _now() > saleEnd) return State.Refund;
  }

  return State.Ended;
}

function CampaignState() public view returns(string) {
  if(_campaignState() == State.PreSale) return "Presale";
  if(_campaignState() == State.Refund) return "Refund";
  if(_campaignState() == State.Campaign) return "Main Sale";
  if(_campaignState() == State.Ended) return "Ended";
  if(_campaignState() == State.Closed) return "Closed";
}

  /// @param _newwallet new wallet address. Must not be zero.
  /// @notice This function change wallet address
  function ChangeWallet (address _newwallet) public onlyOwner returns (bool)
  {
    require (_newwallet != 0x0,"New Wallet is zero");
    wallet = _newwallet;
  }

  /// @notice This function sets tokenaddress if it hasn't been yet set.
  /// @dev You can call this function only once. If you set token and it is wrong address then you have to create new crowdsale function
    function SetTokenAddress (address _tokenAddress) public onlyOwner returns (bool)
  {
    require (_tokenAddress != address(0x0),"Token Address is Zero");
    require (token == ERC20(0x0),"Token was already defined");

    token = ERC20( _tokenAddress);
  }


  constructor (uint _price,address _wallet, ERC20 _song, uint _teamTokens,uint256[] constraints , uint _duration, uint _presaleduration,uint8[] bonuses) public Crowdsale(_price,_wallet,ERC20(_song))
  {


    uint _minpresale = constraints[0];
    uint _minMainSaleETH = constraints[1];
    uint _maxEth = constraints[2];
    uint _maxCap = constraints[3];
    uint _minCap = constraints[4];

    token = _song;

     minPreSaleETH = _minpresale;
     minMainSaleETH = _minMainSaleETH;
     maxEth = _maxEth;
     maxCap = _maxCap;
     minCap = _minCap;
     durationDays = _duration;
     preSaleDays = _presaleduration;
     saleStart = _now();
     preSaleEnd = saleStart + (preSaleDays * 24 * 60 * 60);
     saleEnd = preSaleEnd + (durationDays * 24 * 60 * 60);
     teamTokens = _teamTokens;
     owner = tx.origin;

     if(bonuses.length==8)
     {
       require (bonuses[0] <= preSaleDays); // bonus period for presale must be smaller or equal than presale itself. Make sense ?
       require ((bonuses[2] + bonuses [4] + bonuses[6]) <= durationDays); // same as above, but for main sale.
       DefineBonusValues(bonuses[1],bonuses[3],bonuses[5],bonuses[7]);
       DefineBonusPeriods(bonuses[0],bonuses[2],bonuses[4],bonuses[6]);
     }

     if ( minPreSaleETH > 0 || minMainSaleETH > 0 ) isRefundable = true;


  }

function withdrawFunds() public returns(bool) {
  require(msg.sender == wallet);
  require(_campaignState() == State.Ended);
  uint256 toSend;
  toSend = weiRaised;
  weiRaised = 0;
  msg.sender.transfer(toSend);
  closed = true;
}

function _now() internal view returns (uint256) {
  if (debug == true) return testNow;
  else return now;
}

function SetTestNow(uint256 _testNow) public onlyOwner {
  testNow = _testNow;
}

  function GetSaleInformation() public view returns (
       uint256 _price,
       address _wallet,
       address _song,
       uint256 _teamTokens,
       uint256 _minpresale,
       uint256 _minMainSaleETH,
       uint256 _maxETH,
       uint256 _minCap,
       uint256 _duration,
       uint256 _presaleduration
       )
  {
      return (rate,wallet,token,teamTokens,minPreSaleETH,minMainSaleETH,maxEth,minCap, durationDays,preSaleDays);
  }

  function GetStats() public view returns (
    uint256 _contribution,
    uint256 _volume,
    uint8 _phase
    )
{
  return (weiRaised, volume,uint8(phase) );
}

function _processPurchase(
  address _beneficiary,
  uint256 _tokenAmount
)
  internal
{
  _deliverTokens(_beneficiary, _tokenAmount);
}

/**
 * @dev low level token purchase ***DO NOT OVERRIDE***
 * @param _beneficiary Address performing the token purchase
 */
function buyTokens(address _beneficiary) public payable returns(bool)  {
  require (refundAvailable == false);
  require (_campaignState() != State.Ended);
  if (_campaignState() == State.Refund) {
    refundAvailable = true;
    msg.sender.transfer(msg.value);
    return;
   }
  uint256 weiAmount = msg.value;
  /* _preValidatePurchase(_beneficiary, weiAmount); */

  // calculate token amount to be created
  uint256 tokens = _getTokenAmount(weiAmount);
  _processPurchase(_beneficiary, tokens);
  emit TokenPurchase(
    msg.sender,
    _beneficiary,
    weiAmount,
    tokens
  );

  _updatePurchasingState(_beneficiary, weiAmount, tokens);
  _postValidatePurchase(_beneficiary, weiAmount);
}

function _getTokenAmount(uint256 _weiAmount)
  internal view returns (uint256)
{

  /* uint256 tokenAmount = _weiAmount.mul(rate).mul(100 + 20).div(100); */
  uint256 tokenAmount = _weiAmount.mul(rate).mul(100 + currentBonusValue()).div(100);
  return tokenAmount;
}


function _preValidatePurchase(
  address _beneficiary,
  uint256 _weiAmount
)
  internal
{
  require(_beneficiary != address(0));
  require(_weiAmount != 0);
}

function _postValidatePurchase(
  address _beneficiary,
  uint256 _weiAmount
)
  internal
{
  if(maxEth > 0) {
    require(weiRaised < maxEth);
  }

  if(maxCap > 0) {
    require(volume < maxCap);
  }
  //cancel if there is not enough tokens for a team
  require(teamTokens <= _balance(this));
}

function _balance(address _who) internal returns (uint256)
{
  return token.balanceOf(_who);
}
function _updatePurchasingState(
  address _beneficiary,
  uint256 _weiAmount,uint256 _tokenAmount
)
  internal
{
  collectedFunds[_beneficiary] = collectedFunds[_beneficiary].add(_weiAmount);
  volume = volume.add(_tokenAmount);
  weiRaised = weiRaised.add(_weiAmount);
}

function () external payable {
  buyTokens(msg.sender);
}

function refund() public {
  require(collectedFunds[msg.sender] > 0);
  require(refundAvailable || _campaignState() == State.Refund);
  refundAvailable = true;
  uint256 toRefund = collectedFunds[msg.sender];
  collectedFunds[msg.sender] = 0;
  msg.sender.transfer(toRefund);
}


function _deliverTokens(
  address _beneficiary,
  uint256 _tokenAmount
)
  internal
{
  token.transfer(_beneficiary, _tokenAmount);
  if(isRefundable == false) {
    _forwardFunds();
  }
}

function GetBalance() public view returns(uint256) {
  return token.balanceOf(this);
}

function GetToken() public view returns(address) {
  return token;
}

}
