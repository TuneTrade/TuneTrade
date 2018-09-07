var TXTToken = artifacts.require("TXTToken");
var TXTSale = artifacts.require("TXTCrowdsale");
require("babel-polyfill")

var chai = require("chai")
var chaiAsPromised = require("chai-as-promised");
chai.use(chaiAsPromised);
expect = chai.expect;

var TXTTokenContract = 0;
var TXTSaleContract = 0;
var TXTSaleContract2 = 0;
// var totalSupply = 0;
var owner = 0;
var rate = 5000;
var saleWallet = 0;
var poolAddress = 0;
var foundersWallet = 0;
var testBuyer = 0;
var testBuyer2 = 0;
var balance = 0;
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
  testBuyer2 = accounts[3]

     describe("Deploy TXT Token Smart Contract and TXT Sale Contract",    function () {

      it("01. Catch an instance of TXT Token Smart Contract", function() {
      return TXTToken.new(foundersWallet).then(function(instance) {
        TXTTokenContract = instance
        return TXTSale.new(rate,saleWallet,TXTTokenContract.address,poolAddress).then((instance2)=>{
          TXTSaleContract = instance2;
            return TXTSale.new(rate,saleWallet,TXTTokenContract.address,poolAddress).then((instance3)=>{
              TXTSaleContract2 = instance3;
              balance = web3.eth.getBalance(saleWallet)
            console.log(' ')
             console.log('    ***********************************************************')
             console.log('    TXT Token:    '.blue, TXTTokenContract.address)
             console.log('    TXT Sale:     '.blue, TXTSaleContract.address)
             console.log('    TXT Sale 2:   '.blue, TXTSaleContract2.address)
             console.log('    Test Buyer:   '.blue, testBuyer)
             console.log('    Test Buyer 2: '.blue, testBuyer2)
             console.log('    Sale Wallet Balance: '.blue,parseInt(web3.fromWei(balance,"ether")))
             console.log('    ***********************************************************')
             console.log(' ')
         })
        })
      });
    })

    it("02. TotalSupply should be 500 000 000 (with 18 decimals)", () => {
      return TXTTokenContract.totalSupply().then((res)=>{
          expect(res/1000000000000000000).to.be.equal(500000000)
      })
    })

    it("03. Pool balance should be 250 000 000 (with 18 decimals)", () => {
      return TXTTokenContract.balanceOf(poolAddress).then((res)=>{
          expect(res/1000000000000000000).to.be.equal(250000000)
      })
    })

    it("04. Founders Wallet balance should be 50 000 000 (with 18 decimals)", () => {
      return TXTTokenContract.balanceOf(foundersWallet).then((res)=>{
          expect(res/1000000000000000000).to.be.equal(50000000)
      })
    })

    it("05. TXTSale Contract Allowance in poolAddress should be zero (with 18 decimals)", () => {
      return TXTTokenContract.allowance(poolAddress,TXTSaleContract.address).then((res)=>{
          expect(res/1000000000000000000).to.be.equal(0)
      })
    })

    it("06. TXTSale Contract Allowance in poolAddress should be set to 250 000 000 and equal 250 million (with 18 decimals)", () => {
      return TXTTokenContract.approve(TXTSaleContract.address,250000000 * 1000000000000000000,{"from":poolAddress}).then((res2)=>{
        return TXTTokenContract.allowance(poolAddress,TXTSaleContract.address).then((res)=>{
          expect(res/1000000000000000000).to.be.equal(250000000)
        })
      })
    })

    it("07. TXTSale Contract Allowance in poolAddress should be set to 250 000 000 and equal 250 million (with 18 decimals)", () => {
      return TXTTokenContract.approve(TXTSaleContract2.address,250000000 * 1000000000000000000,{"from":poolAddress}).then((res2)=>{
        return TXTTokenContract.allowance(poolAddress,TXTSaleContract2.address).then((res)=>{
          expect(res/1000000000000000000).to.be.equal(250000000)
        })
      })
    })

    it("08. Test Buyer balance should be 0 (with 18 decimals)", () => {
      return TXTTokenContract.balanceOf(testBuyer).then((res)=>{
          expect(res/1000000000000000000).to.be.equal(0)
      })
    })

    it("09. Sale Contract should have 250 million tokens available (with 18 decimals)", () => {
      return TXTSaleContract.availableTokens().then((res)=>{
        // console.log(res)
          expect(res[1]/1000000000000000000).to.be.equal(250000000)
      })
      })

    it("10. Sale Contract #2 should have 250 million tokens available (with 18 decimals)", () => {
      return TXTSaleContract2.availableTokens().then((res)=>{
        // console.log(res)
          expect(res[1]/1000000000000000000).to.be.equal(250000000)
      })
      })

    it("11. Should be able to buy 5000 tokens for 1 ether from Sale Contract #1 (with 18 decimals)", () => {
      return expect(TXTSaleContract.sendTransaction({"value":web3.toWei(1,"ether"),"from":testBuyer})).to.be.eventually.fulfilled;
      })

    it("12. Should be able to buy 5000 tokens for 1 ether from Sale Contract #2 (with 18 decimals)", () => {
      return expect(TXTSaleContract2.sendTransaction({"value":web3.toWei(1,"ether"),"from":testBuyer})).to.be.eventually.fulfilled;
      })

      it("13. Test Buyer balance should be 2 x 5000 TXT + 100% bonus == 20 000 TXT (with 18 decimals)", () => {
        return TXTTokenContract.balanceOf(testBuyer).then((res)=>{
            expect(res/1000000000000000000).to.be.equal(10000)
        })
      })

    it("14. Should be not be  able to buy  tokens for less than 0.1 ether", () => {
      return expect (TXTSaleContract.send(web3.toWei(0.099,"ether"),{"from":testBuyer})).to.be.eventually.rejected;
      })


      it("15. Sale Contract #1 should have 250 million tokens available minus 10 000 (with 18 decimals)", () => {
        return TXTSaleContract.availableTokens().then((res)=>{
          // console.log(res)
            expect(parseInt(res[1]/1000000000000000000)).to.be.equal(250000000 - 5000)
        })
      })

      it("16. Sale Contract #2 should have 250 million tokens available minus 10 000 (with 18 decimals)", () => {
        return TXTSaleContract2.availableTokens().then((res)=>{
          // console.log(res)
            expect(parseInt(res[1]/1000000000000000000)).to.be.equal(250000000 - 5000)
        })
      })

      it("17. Pool balance should be 250 000 000 - 10 000 - 10 000 (with 18 decimals)", () => {
        return TXTTokenContract.balanceOf(poolAddress).then((res)=>{
            expect(parseInt(res/1000000000000000000)).to.be.equal(250000000 - 10000)
        })
      })

      it("18. Sale Wallet Balance should be bigger by 2 ether", () => {
        var balanceEnd = web3.eth.getBalance(saleWallet)
        balanceEnd = parseInt(web3.fromWei(balanceEnd,"ether"))
        balance = parseInt(web3.fromWei(balance,"ether"))

        return expect(balanceEnd).to.be.equal(balance+2)
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
