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

  /// @param _newwallet new wallet address. Must not be zero.
  /// @notice This function change wallet address
  function ChangeWallet (address _newwallet) public onlyOwner returns (bool)
  {
    require (_newwallet != 0x0);
    wallet = _newwallet;
  }

  /// @notice This function sets tokenaddress if it hasn't been yet set.
  /// @dev You can call this function only once. If you set token and it is wrong address then you have to create new crowdsale function
    function SetTokenAddress (address _tokenAddress) public onlyOwner returns (bool)
  {
    require (_tokenAddress != address(0x0));
    require (token == ERC20(0x0));

    token =ERC20( _tokenAddress);
  }

  function AddICO(address _wallet,uint256 _teamstokens,uint256 _minpresale, uint256 _minMainSale, uint256 maxEth, uint256  _maxCap, uint256 minCap, uint256 _price, uint256 _durationDays)
  {

  }


  constructor (uint _price,address _wallet, ERC20 _song, uint _teamTokens, uint _minpresale, uint _minMainSaleETH, uint _maxEth, uint _maxCap, uint _minCap, uint _duration, uint _presaleduration) public Crowdsale(_price,_wallet,ERC20(_song))
  {
     teamTokens = _teamTokens;
     minPreSaleETH = _minpresale;
     minMainSaleETH = _minMainSaleETH;
     maxEth = _maxEth;
     maxCap = _maxCap;
     minCap = _minCap;
     durationDays = _duration;
     preSaleDays = _presaleduration;

  }

  function GetSaleInformation() public view returns (uint256 _price,address _wallet, address _song)
  {
      return (rate,wallet,token);
  }

}
