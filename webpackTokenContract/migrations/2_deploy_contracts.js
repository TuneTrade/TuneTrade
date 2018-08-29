var Token = artifacts.require("./TXTToken.sol");
var Sale = artifacts.require("./TXTCrowdsale.sol");


module.exports = function(deployer,network,accounts) {
  deployer.deploy(Token,accounts[2]).then(function(){
    return deployer.deploy(Sale,5000, accounts[1], Token.address, accounts[0])
  })
};
