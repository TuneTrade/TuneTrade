pragma solidity ^0.4.24;
/* pragma experimental ABIEncoderV2; */


import "./StandardToken.sol";
import "./DetailedERC20.sol";
import "./Crowdsale.sol";
import "./SongCrowdsale.sol";
import "./SongERC20.sol";



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

  function AddICO(address _wallet,uint256 _teamTokens,uint256 _minpresale, uint256 _minMainSale, uint256 _maxEth, uint256  _maxCap, uint256 _minCap, uint256 _price, uint256 _durationDays, uint _presaleduration)
  {
    ERC20 songToken = ERC20(userToSongICO[msg.sender]);
    require (userToSongICO[msg.sender] != address(0x0));

    SongCrowdSale saleContract = new SongCrowdSale(_price,_wallet,songToken,_teamTokens,_minpresale, _minMainSale,_maxEth,_maxCap, _minCap, _durationDays, _presaleduration);
    songToSale[songToken] = saleContract;

  }


  function AddSongFull(string _name, string _author,string _genre, uint8 _entryType,string _website,uint _totalSupply,string _symbol,string _description,string _soundcloud,bool _ico)
  {

    SongERC20 song = new SongERC20(msg.sender, _totalSupply, _name, _symbol, 0);
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
      0);

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



}
