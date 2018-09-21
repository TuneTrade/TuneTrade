pragma solidity ^0.4.24;


import "./StandardToken.sol";
import "./Ownable.sol";


contract SongERC20 is StandardToken, Ownable
{
  enum Type {Song,Band,Influencer}

  string public author;
  string public genre;
  address TuneTrader;
  Type public entryType; //true - band, false - song
  uint public creationTime;
  string public website;
  string soundcloud;
  string description;
  uint256 id;

  string public name;
  string public symbol;
  uint256 public decimals;

  modifier onlyTuneTrader {
    require (msg.sender == TuneTrader);
    _;
  }
  constructor (address _owner, uint _supply,string _name, string _symbol, uint256 _decimals,uint256 _id)  public
  {
    owner = _owner;
    totalSupply_ = _supply;
    creationTime = now;
    id = _id;
    balances[owner] = totalSupply_;
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
    TuneTrader = msg.sender;
  }

  function AssignICOTokens(address _ico, uint256 _amount)  onlyTuneTrader {

    require(balances[owner] >= _amount);
    balances[owner] = balances[owner].sub(_amount);
    balances[_ico] = balances[_ico].add(_amount);
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

  function GetTokenDetails() public view returns (address _owner, uint256 _supply, string _name, string _symbol, uint256 _decimals,uint256 _creationTime) {
    return (owner,totalSupply_,name,symbol,decimals,creationTime);
  }


}
