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
  enum State {PreSale,Campaign,Ended,Refund}
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

  uint8[] bonusValues;

  uint256 bonusPresalePeriod;
  uint256 firstPeriod;
  uint256 secondPeriod;
  uint256 thirdPeriod;

  uint256 bonusPreSaleValue;
  uint256 bonusFirstValue;
  uint256 bonusSecondValue;
  uint256 bonusThirdValue;


  // 0 - presale 1 - first period 2-second period 3 - third period
  uint8[] bonusPeriods;
  uint256 volume;
  uint256 phase=1;

  uint saleStart;

  bool refundAvailable = false;
  bool isRefundable = false;

  mapping (address=>uint256) collectedFunds;


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
      if (now < (saleStart + (bonusPresalePeriod * 24 * 60 * 60))) {
        return bonusPreSaleValue;
      }
      return 0;

    }
    if(_campaignState() == State.Campaign) {
      if (now > ((saleStart + (firstPeriod + secondPeriod + thirdPeriod) * 24 * 3600 ))) return 0;
      if (now > ((saleStart + (firstPeriod + secondPeriod) * 24 * 3600 ))) return bonusThirdValue;
      if (now > ((saleStart + (firstPeriod) * 24 * 3600 ))) return bonusSecondValue;
      if (now > (saleStart)) return bonusFirstValue;
      return 0;
    }
    return 0;

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
     saleStart = now;
     preSaleEnd = saleStart + (preSaleDays * 24 * 60 * 60);
     saleEnd = preSaleEnd + (durationDays * 24 * 60 * 60);

     if(bonuses.length==8)
     {
       DefineBonusValues(bonuses[1],bonuses[3],bonuses[5],bonuses[7]);
       DefineBonusPeriods(bonuses[0],bonuses[2],bonuses[4],bonuses[6]);
     }

     if ( minPreSaleETH > 0 || minMainSaleETH > 0 ) isRefundable = true;

  }

  function _campaignState() public view returns (State _state)
  {
    /* enum State {PreSale,Campaign,Ended, Refund} */
    assert (now > saleStart);
    if (refundAvailable) return State.Refund;
    if (now <= preSaleEnd) return State.PreSale;
    if  (now > preSaleEnd && now < saleEnd)
    {
      if(weiRaised < minPreSaleETH) return State.Refund;
      else return State.Campaign;
    }
    if (weiRaised < minMainSaleETH) return State.Refund;

    if (minCap > 0 ) {
      if(volume < minCap && now > saleEnd) return State.Refund;
    }
    else return State.Ended;
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
    uint256 contribution,
    uint256 volume,
    uint8 phase
    )
{
  return (weiRaised, volume,phase );
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
function buyTokens(address _beneficiary) public payable {
  /* require (refundAvailable == false); */
  /* if (_campaignState() == State.Refund) { */
    /* refundAvailable = true; */
    /* msg.sender.transfer(msg.value); */
    /* return; */
  /* } */
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

  return;
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
  /* if(maxEth > 0) {
    require(weiRaised < maxEth);
  }

  if(maxCap > 0) {
    require(volume < maxCap);
  } */
  /* uint256 i = token.balanceOf(this); */
  //cancel if there is not enough tokens for a team
  require(0 <= _balance(this));
  /* require(teamTokens <= 1,"Problem"); */
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
  require(refundAvailable);
  msg.sender.transfer(collectedFunds[msg.sender]);
}

function _deliverTokens(
  address _beneficiary,
  uint256 _tokenAmount
)
  internal
{
  uint256 tokenAmount = _tokenAmount + _tokenAmount.mul(currentBonusValue()).div(100);
  token.transfer(_beneficiary, tokenAmount);
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
