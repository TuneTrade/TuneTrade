var TuneTraderExchange = artifacts.require("./TuneTraderExchange.sol");
module.exports = function(deployer) {
  deployer.deploy(TuneTraderExchange).then(async() => {
    var c = await TuneTraderExchange.deployed();
  });
};
