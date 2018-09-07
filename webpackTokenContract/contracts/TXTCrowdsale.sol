pragma solidity 0.4.24;

import "./Ownable.sol";
import "./SafeMath.sol";
import "./StandardToken.sol";
import "./SafeERC20.sol";

contract TXTCrowdsale is Ownable{

  using SafeMath for uint256;
  using SafeERC20 for ERC20;

  // The token being sold
  ERC20 public token;
  // Address where funds are collected
  address public wallet;
  // How many token units a buyer gets per wei.
  // The rate is the conversion between wei and the smallest and indivisible token unit.
  // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
  // 1 wei will give you 1 unit, or 0.001 TOK.
  uint256 public rate;
  // Amount of wei raised
  uint256 public weiRaised;
  /**
   * Event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(
    address indexed purchaser,
    address indexed beneficiary,
    uint256 value,
    uint256 amount
  );

  bool private paused = false;
  uint private phase = 0;
  enum State {New,Started,Finished,Closed}
  uint8 [] private bonuses = [0,100,50,25,0];
  address private poolAccount;
  State state;

  /* uint256[] bonusPeriodsStart = [
  1542240000, //November 15 2018
  1544832000, //December 15 2018
  1547510400, //January 15 2019
  1550188800, //February 15 2019
  1551312000  //FFebruary 28 2019
  ]; */


 uint256[] bonusPeriodsStart = [
    now,
    now+60,
    now+120,
    now+180,
    now+240
  ];


  function Pause()  public onlyOwner {
    paused = true;
  }

  function UnPause() public onlyOwner {
    paused = false;
  }

  function bonusPeriod() public returns (uint256)
  {
    if (now > bonusPeriodsStart[3]) return 0;
    if (now > bonusPeriodsStart[2]) return 25;
    if (now > bonusPeriodsStart[1]) return 50;
    if (now >= bonusPeriodsStart[0]) return 100;
  }

  function _saleIsNew() internal returns (bool) {
    return (now < bonusPeriodsStart[0]);

  }

  function _saleIsFinished() internal returns(bool) {
   return (now > bonusPeriodsStart[4]);
  }

  function _transferRemainingTokens() internal returns (bool)
  {
      require(state != State.Closed);
      uint256 tokens = token.balanceOf(this);
      token.safeTransfer(wallet,tokens);
      state = State.Closed;
      return true;
  }


  constructor (uint _price, address _wallet, ERC20 _token, address _poolAccount) public
  {
    require(_wallet != address(0));
    require(_token != address(0));

    state = State.New;
    poolAccount = _poolAccount;

    rate = 2500;
    wallet = _wallet;
    token = _token;

  }

  // -----------------------------------------
  // Internal interface (extensible)
  // -----------------------------------------


  /**
   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
   * Example from CappedCrowdsale.sol's _preValidatePurchase method:
   *   super._preValidatePurchase(_beneficiary, _weiAmount);
   *   require(weiRaised.add(_weiAmount) <= cap);
   * @param _beneficiary Address performing the token purchase
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _preValidatePurchase(
    address _beneficiary,
    uint256 _weiAmount
  )
    internal
  {
    require (_weiAmount >= 0.1 ether);
    require(_beneficiary != address(0));
  }


    /**
     * @dev Override to extend the way in which ether is converted to tokens.
     * @param _weiAmount Value in wei to be converted into tokens
     * @return Number of tokens that can be purchased with the specified _weiAmount
     */
    function _getTokenAmount(uint256 _weiAmount)
      internal view returns (uint256)
    {
      return _weiAmount.mul(rate);
    }

    /**
     * @dev Determines how ETH is stored/forwarded on purchases.
     */
    function _forwardFunds() internal {
      wallet.transfer(msg.value);
    }


  // -----------------------------------------
  // Crowdsale external interface
  // -----------------------------------------


  /**
   * @dev fallback function ***DO NOT OVERRIDE***
   */
  function () external payable {

    buyTokens(msg.sender);
  }


 function FinishSale() public returns(bool) {

   require (_saleIsFinished());
   msg.sender.transfer(msg.value);
   _transferRemainingTokens();
   return true;

 }
  /**
   * @dev low level token purchase ***DO NOT OVERRIDE***
   * @param _beneficiary Address performing the token purchase
   */
  function buyTokens(address _beneficiary) public payable {
    require(paused == false);
    require(_saleIsNew() == false);
    require(_saleIsFinished () == false);
    uint256 bonus = bonusPeriod();

    uint256 weiAmount = msg.value;
    _preValidatePurchase(_beneficiary, weiAmount);

    // calculate token amount to be created
    uint256 tokens = _getTokenAmount(weiAmount);
    tokens = tokens.add(tokens.mul(bonus).div(100));

    weiRaised = weiRaised.add(weiAmount);
    _processPurchase(_beneficiary, tokens);

    emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
    _forwardFunds();
  }

  function _processPurchase(
    address _beneficiary,
    uint256 _tokenAmount
  )
    internal
  {
    _deliverTokens(_beneficiary, _tokenAmount);
  }


  function _deliverTokens(
    address _beneficiary,
    uint256 _tokenAmount
  )
    internal
  {
    token.safeTransferFrom(poolAccount,_beneficiary, _tokenAmount);
  }

  function availableTokens() public view returns (uint256 _balance, uint256 _poolApproval)
  {
    return (token.balanceOf(this), token.allowance(poolAccount,this));
  }

}
