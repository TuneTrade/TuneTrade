  pragma solidity ^0.4.24;

  // File: contracts\ERC20Basic.sol

  /**
   * @title ERC20Basic
   * @dev Simpler version of ERC20 interface
   * See https://github.com/ethereum/EIPs/issues/179
   */
  contract ERC20Basic {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
  }

  // File: contracts\ERC20.sol

  /**
   * @title ERC20 interface
   * @dev see https://github.com/ethereum/EIPs/issues/20
   */
  contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender)
      public view returns (uint256);

    function transferFrom(address from, address to, uint256 value)
      public returns (bool);

    function approve(address spender, uint256 value) public returns (bool);
    event Approval(
      address indexed owner,
      address indexed spender,
      uint256 value
    );
  }

  // File: contracts\SafeERC20.sol

  /**
   * @title SafeERC20
   * @dev Wrappers around ERC20 operations that throw on failure.
   * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
   * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
   */
  library SafeERC20 {
    function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
      require(token.transfer(to, value));
    }

    function safeTransferFrom(
      ERC20 token,
      address from,
      address to,
      uint256 value
    )
      internal
    {
      require(token.transferFrom(from, to, value));
    }

    function safeApprove(ERC20 token, address spender, uint256 value) internal {
      require(token.approve(spender, value));
    }
  }

  // File: contracts\SafeMath.sol

  /**
   * @title SafeMath
   * @dev Math operations with safety checks that throw on error
   */
  library SafeMath {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
      // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
      // benefit is lost if 'b' is also tested.
      // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
      if (a == 0) {
        return 0;
      }

      c = a * b;
      assert(c / a == b);
      return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
      // assert(b > 0); // Solidity automatically throws when dividing by 0
      // uint256 c = a / b;
      // assert(a == b * c + a % b); // There is no case in which this doesn't hold
      return a / b;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
      c = a + b;
      assert(c >= a);
      return c;
    }
  }

  // File: contracts\Crowdsale.sol

  /**
   * @title Crowdsale
   * @dev Crowdsale is a base contract for managing a token crowdsale,
   * allowing investors to purchase tokens with ether. This contract implements
   * such functionality in its most fundamental form and can be extended to provide additional
   * functionality and/or custom behavior.
   * The external interface represents the basic interface for purchasing tokens, and conform
   * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
   * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
   * the methods to add functionality. Consider using 'super' where appropiate to concatenate
   * behavior.
   */
  contract Crowdsale {
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

    /**
     * @param _rate Number of token units a buyer gets per wei
     * @param _wallet Address where collected funds will be forwarded to
     * @param _token Address of the token being sold
     */
    constructor(uint256 _rate, address _wallet, ERC20 _token) public {
      require(_rate > 0);
      require(_wallet != address(0));
      require(_token != address(0));

      rate = _rate;
      wallet = _wallet;
      token = _token;
    }

    // -----------------------------------------
    // Crowdsale external interface
    // -----------------------------------------

    /**
     * @dev fallback function ***DO NOT OVERRIDE***
     */



    // -----------------------------------------
    // Internal interface (extensible)
    // -----------------------------------------

    /**
     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
     * @param _beneficiary Address performing the token purchase
     * @param _weiAmount Value in wei involved in the purchase
     */
    function _preValidatePurchase(
      address _beneficiary,
      uint256 _weiAmount
    )
      internal
    {
      require(_beneficiary != address(0));
      require(_weiAmount != 0);
    }

    /**
     * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
     * @param _beneficiary Address performing the token purchase
     * @param _weiAmount Value in wei involved in the purchase
     */
    function _postValidatePurchase(
      address _beneficiary,
      uint256 _weiAmount
    )
      internal
    {
      // optional override
    }

    /**
     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
     * @param _beneficiary Address performing the token purchase
     * @param _tokenAmount Number of tokens to be emitted
     */

    /**
     * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
     * @param _beneficiary Address receiving the tokens
     * @param _tokenAmount Number of tokens to be purchased
     */

    /**
     * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
     * @param _beneficiary Address receiving the tokens
     * @param _weiAmount Value in wei involved in the purchase
     */
    function _updatePurchasingState(
      address _beneficiary,
      uint256 _weiAmount
    )
      internal
    {
      // optional override
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
  }

  // File: contracts\DetailedERC20.sol

  /**
   * @title DetailedERC20 token
   * @dev The decimals are only for visualization purposes.
   * All the operations are done using the smallest and indivisible token unit,
   * just as on Ethereum all the operations are done in wei.
   */
  contract DetailedERC20 is ERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;

    constructor(string _name, string _symbol, uint8 _decimals) public {
      name = _name;
      symbol = _symbol;
      decimals = _decimals;
    }
  }

  // File: contracts\Ownable.sol

  /**
   * @title Ownable
   * @dev The Ownable contract has an owner address, and provides basic authorization control
   * functions, this simplifies the implementation of "user permissions".
   */
  contract Ownable {
    address public owner;


    event OwnershipRenounced(address indexed previousOwner);
    event OwnershipTransferred(
      address indexed previousOwner,
      address indexed newOwner
    );


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
      owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
      require(msg.sender == owner);
      _;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
      emit OwnershipRenounced(owner);
      owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param _newOwner The address to transfer ownership to.
     */
    function transferOwnership(address _newOwner) public onlyOwner {
      _transferOwnership(_newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param _newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address _newOwner) internal {
      require(_newOwner != address(0));
      emit OwnershipTransferred(owner, _newOwner);
      owner = _newOwner;
    }
  }

  // File: contracts\BasicToken.sol

  /**
   * @title Basic token
   * @dev Basic version of StandardToken, with no allowances.
   */
  contract BasicToken is ERC20Basic {
    using SafeMath for uint256;

    mapping(address => uint256) balances;

    uint256 totalSupply_;

    /**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
      return totalSupply_;
    }

    /**
    * @dev Transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) public returns (bool) {
      require(_to != address(0));
      require(_value <= balances[msg.sender]);

      balances[msg.sender] = balances[msg.sender].sub(_value);
      balances[_to] = balances[_to].add(_value);
      emit Transfer(msg.sender, _to, _value);
      return true;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) public view returns (uint256) {
      return balances[_owner];
    }

  }

  // File: contracts\StandardToken.sol

  /**
   * @title Standard ERC20 token
   *
   * @dev Implementation of the basic standard token.
   * https://github.com/ethereum/EIPs/issues/20
   * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
   */
  contract StandardToken is ERC20, BasicToken {

    mapping (address => mapping (address => uint256)) internal allowed;


    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
    function transferFrom(
      address _from,
      address _to,
      uint256 _value
    )
      public
      returns (bool)
    {
      require(_to != address(0));
      require(_value <= balances[_from]);
      require(_value <= allowed[_from][msg.sender]);

      balances[_from] = balances[_from].sub(_value);
      balances[_to] = balances[_to].add(_value);
      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
      emit Transfer(_from, _to, _value);
      return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _spender, uint256 _value) public returns (bool) {
      allowed[msg.sender][_spender] = _value;
      emit Approval(msg.sender, _spender, _value);
      return true;
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(
      address _owner,
      address _spender
     )
      public
      view
      returns (uint256)
    {
      return allowed[_owner][_spender];
    }

    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _addedValue The amount of tokens to increase the allowance by.
     */
    function increaseApproval(
      address _spender,
      uint256 _addedValue
    )
      public
      returns (bool)
    {
      allowed[msg.sender][_spender] = (
        allowed[msg.sender][_spender].add(_addedValue));
      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
      return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseApproval(
      address _spender,
      uint256 _subtractedValue
    )
      public
      returns (bool)
    {
      uint256 oldValue = allowed[msg.sender][_spender];
      if (_subtractedValue > oldValue) {
        allowed[msg.sender][_spender] = 0;
      } else {
        allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
      }
      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
      return true;
    }

  }

  // File: contracts\SongCrowdsale.sol

  /* pragma experimental ABIEncoderV2; */

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

  // File: contracts\SongERC20.sol

  /* pragma experimental ABIEncoderV2; */


  contract SongERC20 is StandardToken, DetailedERC20, Ownable
  {
    enum Type {Song,Band,Influencer}

    string public author;
    string public genre;
    Type public entryType; //true - band, false - song
    uint public creationTime;
    string public website;
    string soundcloud;
    string description;
    uint256 id;



    constructor (address _owner, uint _supply,string _name, string _symbol, uint8 _decimals,uint256 _id)  DetailedERC20(_name,_symbol,_decimals) public
    {
      // we have to overwirte original Ownable contract owner because msg.sender is equal to TuneTrade contract.
      owner = _owner;
      totalSupply_ = _supply;
      creationTime = now;
      id = _id;

    }

    function SetDetails(string _author, string _genre, uint8 _entryType, string _website, string _soundcloud, string _description) public returns (bool) {

      author = _author;
      genre = _genre;
      entryType = Type(_entryType);
      website = _website;
      soundcloud = _soundcloud;
      description = _description;
    }

    function GetDetails() public view returns (string memory _author, string memory _genre, uint8  _entryType, string memory _website, string memory _soundcloud, string memory _description, uint256 _id)
    {
      return (author, genre, uint8(entryType), website, soundcloud, description,id);
    }

    function GetTokenDetails() public view returns (address _owner, uint256 _supply, string _name, string _symbol, uint8 decimals,uint256 _creationTime) {
      return (owner,totalSupply_,name,symbol,decimals,creationTime);
    }


  }

  // File: contracts\TuneTrader.sol

  /* pragma experimental ABIEncoderV2; */



  contract TuneTrader {

    enum Type {Song,Band,Influencer}

    uint public i = 1;
    address public owner = 0x0;
    mapping(address=>address) userToSongICO;

    constructor  () public {
      owner = msg.sender;
      AddSong("Poor Little Fool","Ricky Nelson");
      AddSong("Rolling in the Deep","Adele ");

    }
    SongERC20 [] songs;
    SongCrowdSale [] salesContracts;
    mapping (address => address) songToSale;

    function AddICO(address _wallet,uint256 _teamTokens,uint256 _minpresale, uint256 _minMainSale, uint256 _maxEth, uint256  _maxCap, uint256 _minCap, uint256 _price, uint256 _durationDays, uint _presaleduration,uint8[] _bonuses) public
    {
      /* uint8[] bonuses; */
      ERC20 songToken = ERC20(userToSongICO[msg.sender]);
      /* require (userToSongICO[msg.sender] != address(0x0),"No Song assigned to this msg.sender to create ICO"); */
      SongCrowdSale saleContract = new SongCrowdSale(_price,_wallet,songToken,_teamTokens,_minpresale, _minMainSale,_maxEth,_maxCap, _minCap, _durationDays, _presaleduration,_bonuses);
      songToSale[songToken] = saleContract;
    }


    function AddSongFull(string _name, string _author,string _genre, uint8 _entryType,string _website,uint _totalSupply,string _symbol,string _description,string _soundcloud,bool _ico,uint _id)
    {

      SongERC20 song = new SongERC20(msg.sender, _totalSupply, _name, _symbol, 0,_id);
      song.SetDetails(_author, _genre, _entryType, _website, _soundcloud, _description);
      songs.push(song);

      if (_ico) {
        userToSongICO[msg.sender] = song;
      }
    }

    function AddSong(string _name, string _author) public
    {
      SongERC20 song = new SongERC20(
        msg.sender,
        1234567,
        _name,
        "_symbol",
        0,1);

        song.SetDetails("Jan Sebastian Bach",
        "Pop",
        1,
        "website",
        "http://soundcloud.com/forss/flickermood",
        "Description. Max 200 Characters"
        );

      songs.push(song);
    }

    function GetSongs() public view returns (SongERC20[])
    {
      return songs;
    }

  function GetICO(SongERC20 song) public view returns(address ico)
  {
    require (songToSale[song] != 0x0);
    return songToSale[song];
  }

  }
