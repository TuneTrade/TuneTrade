pragma solidity ^0.4.24;
/* pragma experimental ABIEncoderV2; */

contract SongERC20
{
  string public name;
  string public author;
  address public owner;
  string public genre;
  bool public isBand; //true - band, false - song
  uint public price;
  uint public creationTime;
  string public website;


  constructor (address _owner)
  {
    owner = _owner;
  }
  /* constructor(string _name, string _author, address _owner,string _genre)
  {
    name = _name;
    author = _author;
    owner = _owner;
    genre = _genre;
    price = 1 finney;
    creationTime = block.timestamp;
    website = "https://google.com";
    isBand = false;
  } */

  /// Returns information how much tokens were already bought and how much fans contributed to this contract
  function getContribution () public view returns (uint8)
  {
    return 55;
  }

  function totalSupply() public returns (uint)
  {
    return 1200;
  }

  function getGenre() public view returns (string)
  {
    return genre;
  }

}


contract TuneTrader {

  struct SongStruct
  {
    string name;
    string author;
    string genre;
    uint price;
    uint creationTime;
    bool isBand;
    uint contribution;
    uint totalSupply;
    uint8 phase; // 1 - pre-sale, 2 - ico1, 3 - ico2, 4 - ico 3; 5 - post ico, 6 - finished, 0 - not running.
    address owner;
    address contractAddress;
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
  mapping (address=>SongStruct) public songsData;
  SongERC20 [] songs;

  function AddSong(string _name, string _author) public
  {
    SongERC20 song = new SongERC20(msg.sender);

    songs.push(song);
    SongStruct memory data = SongStruct(_name,_author,"Pop",1,block.timestamp,false,35,20000,1,msg.sender,song);
    songsData[song] = data;

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

  function GetSongDetailsPart1(address _song) public view returns (string _name, string _author, string _genre, uint _price, uint _creationTime,address _contractAddress)
  {
    require (songsData[_song].creationTime > 0);
    return (songsData[_song].name, songsData[_song].author, songsData[_song].genre, songsData[_song].price, songsData[_song].creationTime,_song);
  }
  function GetSongDetailsPart2(address _song) public view returns (bool _isBand, uint _contribution, uint _totalSupply, uint8 _phase, address _owner, address _contractAddress )
  {
    require (songsData[_song].creationTime > 0);
    return (songsData[_song].isBand,songsData[_song].contribution,songsData[_song].totalSupply,songsData[_song].phase,songsData[_song].owner,_song);
  }
  /* function GetSongDetails(address _song) public view returns (string _name, string _author, string _genre, uint _price, uint _creationTime,bool _band, uint _contribution, uint _totalSupply, uint8 _phase, address _owner)
  {
    require (songsData[_song].creationTime > 0);
    return (songsData[_song].name,songsData[_song].author,songsData[_song].genre,songsData[_song].price,songsData[_song].creationTime,songsData[_song].isBand, songsData[_song].contribution,songsData[_song].totalSupply,songsData[_song].phase,songsData[_song].owner);
  } */


}
