positionDefinition =  [
  {
    "constant": true,
    "inputs": [],
    "name": "owner",
    "outputs": [
      {
        "name": "",
        "type": "address"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "_newOwner",
        "type": "address"
      }
    ],
    "name": "transferOwnership",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "name": "_token",
        "type": "address"
      },
      {
        "name": "_volume",
        "type": "uint256"
      },
      {
        "name": "_buySell",
        "type": "bool"
      },
      {
        "name": "_cost",
        "type": "uint256"
      },
      {
        "name": "_owner",
        "type": "address"
      }
    ],
    "payable": true,
    "stateMutability": "payable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "weiAmount",
        "type": "uint256"
      },
      {
        "indexed": false,
        "name": "from",
        "type": "address"
      }
    ],
    "name": "ReceivedPayment",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "tokenAmount",
        "type": "uint256"
      },
      {
        "indexed": false,
        "name": "tokenOwner",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "from",
        "type": "address"
      }
    ],
    "name": "ReceivedTokens",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [],
    "name": "PositionCancelled",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [],
    "name": "PositionClosed",
    "type": "event"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "_tokenSender",
        "type": "address"
      },
      {
        "name": "_value",
        "type": "uint256"
      },
      {
        "name": "_data",
        "type": "bytes"
      }
    ],
    "name": "tokenFallback",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [],
    "name": "BuyTokens",
    "outputs": [],
    "payable": true,
    "stateMutability": "payable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [],
    "name": "CancelPosition",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "GetPositionData",
    "outputs": [
      {
        "name": "_token",
        "type": "address"
      },
      {
        "name": "_volume",
        "type": "uint256"
      },
      {
        "name": "_buySell",
        "type": "bool"
      },
      {
        "name": "_created",
        "type": "uint256"
      },
      {
        "name": "_cost",
        "type": "uint256"
      },
      {
        "name": "_customer",
        "type": "address"
      },
      {
        "name": "_managerAddress",
        "type": "address"
      },
      {
        "name": "_active",
        "type": "bool"
      },
      {
        "name": "_tokenBalance",
        "type": "uint256"
      },
      {
        "name": "_weiBalance",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  }
]