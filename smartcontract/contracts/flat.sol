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

// File: contracts\TuneTrader.sol

/* pragma experimental ABIEncoderV2; */

contract SongERC20 is StandardToken, DetailedERC20
{
  enum Type {Song,Band,Influencer}
  string public name;
  string public author;
  address public owner;
  string public genre;
  Type public entryType; //true - band, false - song
  uint public price;
  uint public creationTime;
  string public website;


  constructor (address _owner, uint _supply,string _name, string _symbol, uint8 _decimals)  DetailedERC20(_name,_symbol,_decimals) public
  {
    owner = _owner;
    totalSupply_ = _supply;
  }

  /// Returns information how much tokens were already bought and how much fans contributed to this contract
  function getContribution () public view returns (uint8)
  {
    return 55;
  }


  function getGenre() public view returns (string)
  {
    return genre;
  }

}


contract TuneTrader {

  enum Type {Song,Band,Influencer}
  struct SongStruct1
  {
    string name;
    string author;
    string genre;
    uint price;
    uint creationTime;
    Type entryType;
    uint contribution;
    uint totalSupply;
    uint8 phase; // 1 - pre-sale, 2 - ico1, 3 - ico2, 4 - ico 3; 5 - post ico, 6 - finished, 0 - not running.
    address owner;
    address contractAddress;
  }

  struct SongStruct2
  {
    uint volume;
    string description;
  }

  uint public i = 1;
  address public owner = 0x0;

  constructor  () public {
    owner = msg.sender;
    AddSong("Poor Little Fool","Ricky Nelson");
    AddSong("Rolling in the Deep","Adele ");
    AddSong("Overload","Sugababes ");
    AddSong("You! Me! Dancing!","Campesinos ");
    AddSong("That’s Not My Name","The Ting Tings");
    AddSong("Dry Your Eyes","The Streets ");
    AddSong("Pull Shapes","The Pipettes");
    AddSong("Rehab","Amy Winehouse");
    AddSong("Uptown Funk","Mark Ronson featuring Bruno Mars");
    AddSong("Take Me Out","Franz Ferdinand");
    AddSong("Paper Planes","M.I.A.");
    AddSong("Silent Sigh","Badly Drawn Boy");
    AddSong("The National Anthem","Radiohead");
    AddSong("Big Exit","PJ Harvey");
    AddSong("The Cedar Room","Doves");

  }
  mapping (address=>SongStruct1) public songsData1;
  mapping (address=>SongStruct2) public songsData2;
  SongERC20 [] songs;

  function AddSongFull(string _name, string _author,string _genre, uint8 _entryType,string _website,uint _price,uint _totalSupply,bool _withICO,string _symbol,string description)
  {
    SongERC20 song = new SongERC20(msg.sender,_totalSupply,_name,_symbol,0);
    songs.push(song);

    SongStruct1 memory data1 = SongStruct1(_name,_author,_genre,_price,block.timestamp,Type(_entryType),35,_totalSupply,1,msg.sender,song);
    SongStruct2 memory data2 = SongStruct2(29238,description);

    songsData1[song] = data1;
    songsData2[song] = data2;

  }

  function AddSong(string _name, string _author) public
  {
    SongERC20 song = new SongERC20(msg.sender,1234567,_name,"_symbol",0);


    songs.push(song);
    SongStruct1 memory data1 = SongStruct1(_name,_author,"Pop",1,block.timestamp,Type.Song,35,20000,1,msg.sender,song);
    SongStruct2 memory data2 = SongStruct2(29238, 'Description. Max 200 Characters');

    songsData1[song] = data1;
    songsData2[song] = data2;

  }

  function GetSongs() public view returns (SongERC20[])
  {
    return songs;
  }

  /* string name;
  string author;
  string genre;
  uint price;
  uint creationTime;
  bool isBand;
  uint contribution;
  uint totalSupply;
  uint8 phase; // 1 - pre-sale, 2 - ico1, 3 - ico2, 4 - ico 3; 5 - post ico, 6 - finished, 0 - not running.
  address owner;
  address contractAddress; */

  function GetSongDetailsPart1(address _song) public view returns (string _name, string _author, string _genre, uint _price, uint _creationTime,address _contractAddress,uint8 _type)
  {
    require (songsData1[_song].creationTime > 0);
    return (songsData1[_song].name, songsData1[_song].author, songsData1[_song].genre, songsData1[_song].price, songsData1[_song].creationTime,_song,uint8(songsData1[_song].entryType));
  }
  function GetSongDetailsPart2(address _song) public view returns (uint _contribution, uint _totalSupply, uint8 _phase, address _owner, address _contractAddress,uint _volume,string _description )
  {
    require (songsData1[_song].creationTime > 0);
    return (songsData1[_song].contribution,songsData1[_song].totalSupply,songsData1[_song].phase,songsData1[_song].owner,_song, songsData2[_song].volume,songsData2[_song].description);
  }
  /* function GetSongDetails(address _song) public view returns (string _name, string _author, string _genre, uint _price, uint _creationTime,bool _band, uint _contribution, uint _totalSupply, uint8 _phase, address _owner)
  {
    require (songsData[_song].creationTime > 0);
    return (songsData[_song].name,songsData[_song].author,songsData[_song].genre,songsData[_song].price,songsData[_song].creationTime,songsData[_song].isBand, songsData[_song].contribution,songsData[_song].totalSupply,songsData[_song].phase,songsData[_song].owner);
  } */


}
