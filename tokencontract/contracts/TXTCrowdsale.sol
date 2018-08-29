pragma solidity ^0.4.24;

import "./Crowdsale.sol";
import "./Ownable.sol";

contract TXTCrowdsale is Crowdsale,Ownable{

  bool private paused = false;
  uint private phase = 0;
  enum State {New,Started,Finished,Closed}
  uint8 [] private bonuses = [0,100,50,25,0];
  State state;
/*
  uint256[] bonusPeriodsStart = [
  1536105600, //September 5 2018
  1542672000, //November 20 2018
  1543622400, //December 01 2018
  1544400000, //December 10 2018
  1545264000  //December 20 2018
  ];
 */

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
    if (now > bonusPeriodsStart[0]) return 1;
    if (now <= bonusPeriodsStart[0]) {
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


  constructor (uint _price, address _wallet, ERC20 _token) public Crowdsale(_price,_wallet,_token)
  {
    state = State.New;
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

    if(state == State.Finished) {
      msg.sender.transfer(msg.value);
      _transferRemainingTokens();
    }
    require(state != State.New);
    uint8 bonus = bonuses[bonusPeriod()];
    require (msg.value > 0.1 ether);
    uint256 weiAmount = msg.value;
    _preValidatePurchase(_beneficiary, weiAmount);

    // calculate token amount to be created
    uint256 tokens = _getTokenAmount(weiAmount);
    if (bonus > 0)
    {
      tokens = tokens.add(tokens.mul(bonus).div(100)); // Calculate bonus and add it to number of tokens user should get in this transaction.
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


}
