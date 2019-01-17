smartContract = [
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
      "type": "function",
      "signature": "0x8da5cb5b"
    },
    {
      "inputs": [
        {
          "name": "_storage",
          "type": "address"
        }
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "constructor",
      "signature": "constructor"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "_wallet",
          "type": "address"
        },
        {
          "name": "_teamTokens",
          "type": "uint256"
        },
        {
          "name": "constraints",
          "type": "uint256[]"
        },
        {
          "name": "_price",
          "type": "uint256"
        },
        {
          "name": "_durationDays",
          "type": "uint256"
        },
        {
          "name": "_presaleduration",
          "type": "uint256"
        },
        {
          "name": "_bonuses",
          "type": "uint8[]"
        },
        {
          "name": "assignedTokens",
          "type": "uint256"
        }
      ],
      "name": "AddICO",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function",
      "signature": "0x4203ac3c"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "_song",
          "type": "address"
        }
      ],
      "name": "RemoveSong",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function",
      "signature": "0x234ea215"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "_name",
          "type": "string"
        },
        {
          "name": "_author",
          "type": "string"
        },
        {
          "name": "_genre",
          "type": "string"
        },
        {
          "name": "_entryType",
          "type": "uint8"
        },
        {
          "name": "_website",
          "type": "string"
        },
        {
          "name": "_totalSupply",
          "type": "uint256"
        },
        {
          "name": "_symbol",
          "type": "string"
        },
        {
          "name": "_description",
          "type": "string"
        },
        {
          "name": "_soundcloud",
          "type": "string"
        },
        {
          "name": "_youtube",
          "type": "string"
        },
        {
          "name": "_ico",
          "type": "bool"
        },
        {
          "name": "_decimals",
          "type": "uint8"
        },
        {
          "name": "_id",
          "type": "uint256"
        }
      ],
      "name": "AddSong",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function",
      "signature": "0xad2ff93b"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "GetMySongs",
      "outputs": [
        {
          "name": "",
          "type": "address[]"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function",
      "signature": "0xc55d6554"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "GetSongs",
      "outputs": [
        {
          "name": "",
          "type": "address[]"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function",
      "signature": "0x1324af41"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "song",
          "type": "address"
        }
      ],
      "name": "Test",
      "outputs": [
        {
          "name": "",
          "type": "uint256"
        },
        {
          "name": "",
          "type": "uint256"
        },
        {
          "name": "",
          "type": "address"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function",
      "signature": "0xaa9449f2"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "song",
          "type": "address"
        }
      ],
      "name": "GetICO",
      "outputs": [
        {
          "name": "ico",
          "type": "address"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function",
      "signature": "0x70c0a4bc"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "GetContractOwner",
      "outputs": [
        {
          "name": "",
          "type": "address"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function",
      "signature": "0x9b276a68"
    }
  ]