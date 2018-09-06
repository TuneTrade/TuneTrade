pragma solidity ^0.4.24;
/* pragma experimental ABIEncoderV2; */


import "./StandardToken.sol";
import "./DetailedERC20.sol";
import "./Crowdsale.sol";
import "./Ownable.sol";

/// @author         Robert Magier
/// @title          SongCrowdSale
/// @notice         This is Song ICO sale contract based on Open Zeppelin Crowdsale contract.
///                 It's purpose is to sell song tokens in main sale and presale.

contract SongCrowdSale is Crowdsale, Ownable
{
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

  uint8[] bonusValues;
  // 0 - presale 1 - first period 2-second period 3 - third period
  uint8[] bonusPeriods;
  uint256 volume;
  uint256 phase=1;

  uint saleStart;


function DefineBonusValues(uint8 value1, uint8 value2, uint8 value3, uint8 value4) internal  returns (bool)
{
  bonusValues.push(value1);
  bonusValues.push(value2);
  bonusValues.push(value3);
  bonusValues.push(value4);
  return true;
}

function DefineBonusPeriods(uint8 period1,uint8 period2,  uint8 period3, uint8 period4) internal  returns (bool)
{
  bonusPeriods.push(period1);
  bonusPeriods.push(period2);
  bonusPeriods.push(period3);
  bonusPeriods.push(period4);
  return true;
}

///@notice Return bonus value for current moment in %. If sale is already out of bonus period it will return 0.
///@dev It will fail if for any reason now is smaller than saleStart
function currentBonusValue() internal returns (uint8)
{
    if (now > saleStart + (bonusPeriods[0] + bonusPeriods[1] + bonusPeriods[2] + bonusPeriods[3]) *24*3600 ) return 0;
    if (now > saleStart + (bonusPeriods[0] + bonusPeriods[1] + bonusPeriods[2]) *24*3600 ) return bonusValues[3];
    if (now > saleStart + (bonusPeriods[0] + bonusPeriods[1]) *24*3600 ) return bonusValues[2];
    if (now > saleStart + (bonusPeriods[0] *24*3600 )) return bonusValues[1];
    if (now > saleStart ) return bonusValues[0];
    assert(now >= saleStart);
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


  constructor (uint _price,address _wallet, ERC20 _song, uint _teamTokens, uint _minpresale, uint _minMainSaleETH, uint _maxEth, uint _maxCap, uint _minCap, uint _duration, uint _presaleduration,uint8[] bonuses) public Crowdsale(_price,_wallet,ERC20(_song))
  {
     teamTokens = _teamTokens;
     minPreSaleETH = _minpresale;
     minMainSaleETH = _minMainSaleETH;
     maxEth = _maxEth;
     maxCap = _maxCap;
     minCap = _minCap;
     durationDays = _duration;
     preSaleDays = _presaleduration;
     saleStart = now;
     if(bonuses.length==8)
     {
       DefineBonusValues(bonuses[1],bonuses[3],bonuses[5],bonuses[7]);
       DefineBonusPeriods(bonuses[0],bonuses[2],bonuses[4],bonuses[6]);
     }

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

  uint256 weiAmount = msg.value;
  _preValidatePurchase(_beneficiary, weiAmount);

  // calculate token amount to be created
  uint256 tokens = _getTokenAmount(weiAmount);

  // update state
  weiRaised = weiRaised.add(weiAmount);

  _processPurchase(_beneficiary, tokens);
  emit TokenPurchase(
    msg.sender,
    _beneficiary,
    weiAmount,
    tokens
  );

  _updatePurchasingState(_beneficiary, weiAmount);

  _forwardFunds();
  _postValidatePurchase(_beneficiary, weiAmount);
}

function () external payable {
  buyTokens(msg.sender);
}


function _deliverTokens(
  address _beneficiary,
  uint256 _tokenAmount
)
  internal
{
  uint256 tokenAmount = _tokenAmount + _tokenAmount.mul(currentBonusValue()).div(100);
  token.safeTransfer(_beneficiary, tokenAmount);
  volume = volume.add(tokenAmount);
}

}
