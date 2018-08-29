var TXTToken = artifacts.require("TXTToken");
var TXTSale = artifacts.require("TXTCrowdsale");
require("babel-polyfill")

var chai = require("chai")
var chaiAsPromised = require("chai-as-promised");
chai.use(chaiAsPromised);
expect = chai.expect;

var TXTTokenContract = 0;
var TXTSaleContract = 0;
// var totalSupply = 0;
var owner = 0;
var rate = 5000;
var saleWallet = 0;
var poolAddress = 0;
var foundersWallet = 0;
var testBuyer = 0;
// Accounts definition
// accounts[9] - founder wallet account in token contract
// accounts[1] - crowdsale wallet account
// accounts[0] - pool account & crowdsale & token contract original creators.
// accounts[2] - test token buyer




// console.log ("  Sale contract state 0 - preico 1 -  icorunning, 2- icopaused, 3 - icofinished 4 -  postico.".green)
contract("01. Testing Token Contract",    (accounts)=>{
  poolAddress = accounts[0]
  saleWallet = accounts[1]
  foundersWallet = accounts[9]
  testBuyer = accounts[2]

     describe("Deploy TXT Token Smart Contract and TXT Sale Contract",    function () {

      it("Catch an instance of TXT Token Smart Contract", function() {
      return TXTToken.new(foundersWallet).then(function(instance) {
        TXTTokenContract = instance
        return TXTSale.new(rate,saleWallet,TXTTokenContract.address,poolAddress).then((instance2)=>{
          TXTSaleContract = instance2;
          console.log(' ')
           console.log('    ***********************************************************')
           console.log('    TXT Token:'.blue,TXTTokenContract.address)
           console.log('    TXT Sale: '.blue,TXTSaleContract.address)
           console.log('    ***********************************************************')
           console.log(' ')
        })
      });
    })

    it("TotalSupply should be 500 000 000 (with 18 decimals)", () => {
      return TXTTokenContract.totalSupply().then((res)=>{
          expect(res/1000000000000000000).to.be.equal(500000000)
      })
    })

    it("Pool balance should be 250 000 000 (with 18 decimals)", () => {
      return TXTTokenContract.balanceOf(poolAddress).then((res)=>{
          expect(res/1000000000000000000).to.be.equal(250000000)
      })
    })

    it("Founders Wallet balance should be 10 000 000 (with 18 decimals)", () => {
      return TXTTokenContract.balanceOf(foundersWallet).then((res)=>{
          expect(res/1000000000000000000).to.be.equal(10000000)
      })
    })

    it("TXTSale Contract Allowance in poolAddress should be zero (with 18 decimals)", () => {
      return TXTTokenContract.allowance(poolAddress,TXTSaleContract.address).then((res)=>{
          expect(res/1000000000000000000).to.be.equal(0)
      })
    })

    it("TXTSale Contract Allowance in poolAddress should be set to 250 000 000 and equal 250 million (with 18 decimals)", () => {
      return TXTTokenContract.approve(TXTSaleContract.address,250000000 * 1000000000000000000,{"from":poolAddress}).then((res2)=>{
        return TXTTokenContract.allowance(poolAddress,TXTSaleContract.address).then((res)=>{
          expect(res/1000000000000000000).to.be.equal(250000000)
        })
      })
    })

    it("Test Buyer balance should be 0 (with 18 decimals)", () => {
      return TXTTokenContract.balanceOf(testBuyer).then((res)=>{
          expect(res/1000000000000000000).to.be.equal(0)
      })
    })

    it("Sale Contract should have 250 million tokens available (with 18 decimals)", () => {
      return TXTSaleContract.availableTokens().then((res)=>{
        console.log(res)
          expect(res[1]/1000000000000000000).to.be.equal(250000000)
      })
      })

    it("Should be able to buy 5000 tokens for 1 wei (with 0 decimals)", () => {
      return expect (TXTSaleContract.send(1,{"from":testBuyer})).to.be.eventually.fulfilled;
      })




  //
  //   it("Change Sale Contract State to icorunning", () => {
  //     return viddoSaleContract.setSaleState(1).then((res)=>{
  //       return viddoSaleContract.getSaleState().then((res2)=>{
  //         expect(parseInt(res2)).to.be.equal(1)
  //       })
  //     })
  //   })
  //   it("Change Sale Contract State to icopaused", () => {
  //     return viddoSaleContract.setSaleState(2).then((res)=>{
  //       return viddoSaleContract.getSaleState().then((res2)=>{
  //         expect(parseInt(res2)).to.be.equal(2)
  //       })
  //     })
  //   })
  //
  //   it("Change Sale Contract State to icofinished", () => {
  //     return viddoSaleContract.setSaleState(3).then((res)=>{
  //       return viddoSaleContract.getSaleState().then((res2)=>{
  //         expect(parseInt(res2)).to.be.equal(3)
  //       })
  //     })
  //   })
  //
  //   it("Change Sale Contract State to postico", () => {
  //     return viddoSaleContract.setSaleState(4).then((res)=>{
  //       return viddoSaleContract.getSaleState().then((res2)=>{
  //         expect(parseInt(res2)).to.be.equal(4)
  //       })
  //     })
  //   })
  //
  //   it("Change Sale Contract State to undfined state. Should fail", () => {
  //     expect(viddoSaleContract.setSaleState(5)).to.be.rejected
  //   })
  //
  //   it("Adding Sale Contract address to whitelist",()=>{
  //   expect(viddoTokenContract.addToWhitelist(viddoSaleContract.address,{"from":accounts[0]})).to.be.eventually.fulfilled
  //   })
  //
  //   it("Transfering 100 tokens to Sale Contract.",()=>{
  //   expect(viddoTokenContract.transfer(viddoSaleContract.address,100,{"from":accounts[0]})).to.be.eventually.fulfilled
  //   })
  //
  //   it("Add accounts[1] to whitelist must be fulfilled",()=>{
  //   expect(viddoTokenContract.addToWhitelist(accounts[1],{"from":accounts[0]})).to.be.eventually.fulfilled
  //   })
  //
  //   console.log ("  Sale contract state 0 - preico 1 -  icorunning, 2- icopaused, 3 - icofinished 4 -  postico.".green)
  //
  //   it("Buying transaction should succeed. Accounts[1] is ON the whitelist and state is postico",()=>{
  //   return expect(viddoSaleContract.sendTransaction({"from":accounts[1],"value":1})).to.be.fulfilled;
  // })
  //
  //   it("Buying transaction should fail. Accounts[1] is ON the whitelist and state is preico",()=>{
  //     return viddoSaleContract.setSaleState(0).then((res)=>{
  //       expect(viddoSaleContract.sendTransaction({"from":accounts[1],"value":1})).to.be.rejected;
  //     })
  //   })
  //   it("Buying transaction should fail. Accounts[1] is ON the whitelist and state is icopaused",()=>{
  //     return viddoSaleContract.setSaleState(2).then((res)=>{
  //       expect(viddoSaleContract.sendTransaction({"from":accounts[1],"value":1})).to.be.rejected;
  //     })
  //   })
  //   it("Buying transaction should fail. Accounts[1] is ON the whitelist and state is icofinished",()=>{
  //     return viddoSaleContract.setSaleState(3).then((res)=>{
  //       expect(viddoSaleContract.sendTransaction({"from":accounts[1],"value":1})).to.be.rejected;
  //     })
  //   })
  //
  //   it("Buying transaction should succeed. Accounts[1] is ON the whitelist and state is icorunning",()=>{
  //     return viddoSaleContract.setSaleState(1).then((res)=>{
  //       expect(viddoSaleContract.sendTransaction({"from":accounts[1],"value":1})).to.be.fulfilled;
  //     })
  //   })
  //
  //   it("Accounts[1] should have two tokens",()=>{
  //     return viddoTokenContract.balanceOf(accounts[1]).then((res)=>{
  //       expect (parseInt(res)).to.be.equal(2);
  //     })
  //   })
  //
  });
})
