pragma solidity ^0.4.24;
/* pragma experimental ABIEncoderV2; */


import "./StandardToken.sol";
import "./DetailedERC20.sol";

contract SongERC20 is StandardToken, DetailedERC20
{
  enum Type {Song,Band,Influencer}
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
