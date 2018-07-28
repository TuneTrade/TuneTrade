// var ConvertLib = artifacts.require("./ConvertLib.sol");
var TuneTrader = artifacts.require("./TuneTrader.sol");

module.exports = function(deployer) {
  // deployer.deploy(ConvertLib);
  // deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(TuneTrader);
};
