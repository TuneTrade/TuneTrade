pragma solidity ^0.4.24;
/* pragma experimental ABIEncoderV2; */


import "./StandardToken.sol";
import "./DetailedERC20.sol";
import "./Ownable.sol";


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
