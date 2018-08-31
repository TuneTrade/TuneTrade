pragma solidity 0.4.24;

import "./Crowdsale.sol";
import "./Ownable.sol";

contract TXTCrowdsale is Crowdsale,Ownable{

  bool private paused = false;
  uint private phase = 0;
  enum State {New,Started,Finished,Closed}
  uint8 [] private bonuses = [0,100,50,25,0];
  address private poolAccount;
  State state;

  /* uint256[] bonusPeriodsStart = [
  1536105600, //September 5 2018
  1542672000, //November 20 2018
  1543622400, //December 01 2018
  1544400000, //December 10 2018
  1545264000  //December 20 2018
  ]; */


 uint256[] bonusPeriodsStart = [
    now,
    now+60,
    now+120,
    now+180,
    now+240
  ];

  modifier notPaused () {
    require(paused == false);
    _;
  }

  function Pause()  onlyOwner public {
    paused = true;
  }

  function UnPause() public onlyOwner {
    paused = false;
  }

  function bonusPeriod() public returns (uint8)
  {
    if (state == State.Closed ) return 5;
    if (now > bonusPeriodsStart[4]) {
      state = State.Finished;
      return 5;
    }
    state = State.Started;
    if (now > bonusPeriodsStart[3]) return 4;
    if (now > bonusPeriodsStart[2]) return 3;
    if (now > bonusPeriodsStart[1]) return 2;
    if (now >= bonusPeriodsStart[0]) return 1;
    if (now < bonusPeriodsStart[0]) {
      state = State.New;
      return 0;
    }
  }

  function _transferRemainingTokens() internal returns (bool)
  {
      require(state == State.Finished);
      uint256 tokens = token.balanceOf(this);
      token.transfer(wallet,tokens);
      state = State.Closed;
  }


  constructor (uint _price, address _wallet, ERC20 _token, address _poolAccount) public Crowdsale(_price,_wallet,_token)
  {
    state = State.New;
    poolAccount = _poolAccount;
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

  /**
   * @dev low level token purchase ***DO NOT OVERRIDE***
   * @param _beneficiary Address performing the token purchase
   */
  function buyTokens(address _beneficiary) public notPaused payable {
    require(state != State.Closed);

    //If crowdsale has been finished contract will wait for one transaction to  close. Closing means
    // that incoming transaction will be refunded, no tokens will be sold and all remaining tokens will be transfered
    // to crowdsale wallet account. Then status will be changed to closed. And it status is closed then all
    // buy transactions are always reverted.
    if(state == State.Finished) {
      msg.sender.transfer(msg.value);
      _transferRemainingTokens();
      return;
    }
    uint8 bonus = bonuses[bonusPeriod()];
    require(state != State.New);
    require (msg.value >= 0.1 ether);
    uint256 weiAmount = msg.value;
    _preValidatePurchase(_beneficiary, weiAmount);

    // calculate token amount to be created
    uint256 tokens = _getTokenAmount(weiAmount);
    if (bonus > 0)
    {
      // Calculate bonus and add it to number of tokens user should get in this transaction.
      tokens = tokens.add(tokens.mul(bonus).div(100));
    }
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
    token.transferFrom(poolAccount,_beneficiary, _tokenAmount);
  }

  function availableTokens() public view returns (uint256 _balance, uint256 _poolApproval)
  {
    return (token.balanceOf(this), token.allowance(poolAccount,this));
  }

}
