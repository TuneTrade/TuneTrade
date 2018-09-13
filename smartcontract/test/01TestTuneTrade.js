var TuneTrader = artifacts.require("TuneTrader");
var SongERC20 = artifacts.require("SongERC20");
var SongCrowdsale = artifacts.require("SongCrowdsale");
// var TXTSale = artifacts.require("TXTCrowdsale");
require("babel-polyfill")

var chai = require("chai")
var chaiAsPromised = require("chai-as-promised");
chai.use(chaiAsPromised);
expect = chai.expect;

var TuneTraderContract = 0;
// var TXTSaleContract = 0;
// var TXTSaleContract2 = 0;
// var totalSupply = 0;
var owner = 0;
var saleWallet = 0;
var poolAddress = 0;
var foundersWallet = 0;
var testBuyer = 0;
var testBuyer2 = 0;
var balance = 0;
var assignTokens = 1000
var teamTokens = 0
var rate = 500;
var mySong = null
var songToken = null
var saleInstance = null
// Accounts definition
// accounts[9] - founder wallet account in token contract
// accounts[1] - crowdsale wallet account
// accounts[0] - pool account & crowdsale & token contract original creators.
// accounts[2] - test token buyer




// console.log ("  Sale contract state 0 - preico 1 -  icorunning, 2- icopaused, 3 - icofinished 4 -  postico.".green)
contract("Test TuneTrader Contract",    (accounts)=>{
  poolAddress = accounts[0]
  saleWallet = accounts[1]
  foundersWallet = accounts[9]
  testBuyer = accounts[2]
  testBuyer2 = accounts[3]

   describe("Deploy TuneTrader  Smart Contract",    function () {
    it("01. Catch an instance of TuneTrader Smart Contract", function() {
      return TuneTrader.new().then(function(instance) {
        TuneTraderContract = instance
        console.log(' ')
        console.log('    ***********************************************************')
        console.log('    TuneTrader Contract:    '.blue, TuneTraderContract.address)
        // console.log('    Test Buyer:   '.blue, testBuyer)
        // console.log('    Test Buyer 2: '.blue, testBuyer2)
        // console.log('    Sale Wallet Balance: '.blue,parseInt(web3.fromWei(balance,"ether")))
        console.log('    ***********************************************************')
        console.log(' ')
      })
    })

    it("02. Should be able to add new Song without ICO",function () {
      return expect(TuneTraderContract.AddSong("TEST","TEST","TEST","1","TEST","11111","SYM","DESC","suondcloud",false,"1")).to.be.eventually.fulfilled;
    })

    it("03. Adding ICO without adding Song first should fail", function () {
      var constraints = [0,0,0,0,0]
      var bonuses = [0,0,0,0,0,0,0,0]
      return expect(TuneTraderContract.AddICO(saleWallet,100,constraints,100,1,1,bonuses,100)).to.be.eventually.rejected
    })

    it("04. Should be able to add new Song with ICO", function () {
      return expect(TuneTraderContract.AddSong("Song Name","Author","Genre",1,"website.com",10000,"SYM","Description","soundcloud.com",true,1)).to.be.eventually.fulfilled;
    })
  // function AddSong(string _name, string _author,string _genre, uint8 _entryType,string _website,uint _totalSupply,string _symbol,string _description,string _soundcloud,bool _ico,uint _id)

  // function AddICO(address _wallet,uint256 _teamTokens,uint256[] constraints, uint256 _price, uint256 _durationDays, uint _presaleduration,uint8[] _bonuses,uint256 assignedTokens) public


    it("05. Adding ICO with added song for ICO should be fulfiled", function () {
      var constraints = [0,0,0,0,0]
      var bonuses = [0,0,0,0,0,0,0,0]
      return  TuneTraderContract.AddICO(saleWallet,teamTokens,constraints,rate,10,10,bonuses,assignTokens).then(function() {
        return TuneTraderContract.GetMySongs().then(function(res) {
          mySong= res[1]
          songToken = SongERC20.at(mySong)
          return TuneTraderContract.GetICO(mySong).then(function (res) {
            console.log("ICO address: ",res)
            saleInstance = SongCrowdsale.at(res)
            return saleInstance.GetToken().then(function (res) {
              console.log('Token Address: ', res)
            return saleInstance.sendTransaction({"gas":914366353, "gasPrice":1, "value":1,"from":accounts[1]}).then(function (res) {
                return songToken.balanceOf(saleInstance.address).then(function (res) {
                  expect(parseInt(res)).to.be.equal(0)
                })
              })
            })
          })
        })
      })
    })

    it("06. User should have two songs in TuneTrader contract ", function () {
      return TuneTraderContract.GetMySongs().then(function(res) {
        expect (res.length).to.equal(2)
      })
    })

    it("07.Should be possible to get song ICO address and ICO contract should have " + assignTokens + " assigned", function () {
      return true
    })

    it("08. Balance should be 500 tokens", function () {
      return saleInstance.GetBalance().then(function (res) {
        console.log('this is balance:', parseInt(res))
        expect(parseInt(res)).to.be.equal(500)
      })
    })

  })
})
