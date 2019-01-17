[
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
      "constant": false,
      "inputs": [
        {
          "name": "token",
          "type": "address"
        },
        {
          "name": "volume",
          "type": "uint256"
        },
        {
          "name": "BuySell",
          "type": "bool"
        },
        {
          "name": "cost",
          "type": "uint256"
        }
      ],
      "name": "AddPosition",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "PositionsCount",
      "outputs": [
        {
          "name": "",
          "type": "uint256"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "GetPositions",
      "outputs": [
        {
          "name": "",
          "type": "address[]"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "adr",
          "type": "address"
        }
      ],
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
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    }
  ]