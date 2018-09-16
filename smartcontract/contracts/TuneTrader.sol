pragma solidity ^0.4.24;
/* pragma experimental ABIEncoderV2; */


import "./StandardToken.sol";
import "./Crowdsale.sol";
import "./SongCrowdsale.sol";
import "./SongERC20.sol";


contract TuneTrader {

  enum Type {Song,Band,Influencer}

  uint public i = 1;
  address public owner = 0x0;
  mapping(address=>address) userToSongICO;
  mapping(address=>address[]) usersSongs;
  mapping (address => address) songToSale;
  SongERC20 [] songs;
  SongCrowdSale [] salesContracts;

  constructor  () public {
    owner = msg.sender;
    /* AddSong("Poor Little Fool","Ricky Nelson","Rock",uint8(Type.Song),"testwebsite.com",10000,"TST","This is Test Description","soundcloud.com",false,0); */
    /* AddSong("Rolling in the Deep","Adele","Rock",uint8(Type.Song),"testwebsite.com",10000,"TST","This is Test Description","soundcloud.com",false,0); */

  }

  function AddICO(address _wallet,uint256 _teamTokens,uint256[] constraints, uint256 _price, uint256 _durationDays, uint _presaleduration,uint8[] _bonuses,uint256 assignedTokens) public
  {
    /* require (constraints.length == 5); */

    require (userToSongICO[msg.sender] != address(0x0),"No Song assigned to this msg.sender to create ICO");
    SongERC20 songToken = SongERC20(userToSongICO[msg.sender]);
    SongCrowdSale saleContract = new SongCrowdSale(_price,_wallet,songToken,_teamTokens, constraints, _durationDays, _presaleduration,_bonuses);

    songToken.AssignICOTokens(address(saleContract),assignedTokens);
    songToSale[address(songToken)] = address(saleContract);
    userToSongICO[msg.sender] = address(0x0);
  }


  function AddSong(string _name, string _author,string _genre, uint8 _entryType,string _website,uint _totalSupply,string _symbol,string _description,string _soundcloud,bool _ico,uint _id)
  {

    SongERC20 song = new SongERC20(msg.sender, _totalSupply, _name, _symbol, 0,_id);
    song.SetDetails(_author, _genre, _entryType, _website, _soundcloud, _description);
    songs.push(song);

    if (_ico) {
      userToSongICO[msg.sender] = song;
    }

    usersSongs[msg.sender].push(song);
  }

  function GetMySongs() public view returns(address[])
  {
    return usersSongs[msg.sender];
  }
  function GetSongs() public view returns (SongERC20[])
  {
    return songs;
  }

  function GetICO(address song) public view returns(address ico)
  {
  require (songToSale[song] != address(0x0));
  return songToSale[song];
  }

}
