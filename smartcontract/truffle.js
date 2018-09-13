// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '5777', // Match any network id
      gas: 914366353
    },
    rinkeby: {
      host: 'https://rinkeby.infura.io/FiZkooYHIsk3keP6qjT7',
      // port: 8545,
      network_id: '*', // Match any network id
      gas: 914366353,
      from: '0xfb8e385876ca18d15308e8e0e2b6d026ddf6995a'
    }
  }
}
