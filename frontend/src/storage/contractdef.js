smartContract =[
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
		"type": "function"
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
			}
		],
		"name": "AddSong",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_song",
				"type": "address"
			}
		],
		"name": "GetSongDetailsPart2",
		"outputs": [
			{
				"name": "_isBand",
				"type": "bool"
			},
			{
				"name": "_contribution",
				"type": "uint256"
			},
			{
				"name": "_totalSupply",
				"type": "uint256"
			},
			{
				"name": "_phase",
				"type": "uint8"
			},
			{
				"name": "_owner",
				"type": "address"
			},
			{
				"name": "_contractAddress",
				"type": "address"
			},
			{
				"name": "_volume",
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
		"constant": true,
		"inputs": [
			{
				"name": "",
				"type": "address"
			}
		],
		"name": "songsData2",
		"outputs": [
			{
				"name": "volume",
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
		"name": "i",
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
				"name": "_isBand",
				"type": "bool"
			},
			{
				"name": "_website",
				"type": "string"
			},
			{
				"name": "_price",
				"type": "uint256"
			},
			{
				"name": "_totalSupply",
				"type": "uint256"
			},
			{
				"name": "_withICO",
				"type": "bool"
			}
		],
		"name": "AddSongFull",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_song",
				"type": "address"
			}
		],
		"name": "GetSongDetailsPart1",
		"outputs": [
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
				"name": "_price",
				"type": "uint256"
			},
			{
				"name": "_creationTime",
				"type": "uint256"
			},
			{
				"name": "_contractAddress",
				"type": "address"
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
				"name": "",
				"type": "address"
			}
		],
		"name": "songsData1",
		"outputs": [
			{
				"name": "name",
				"type": "string"
			},
			{
				"name": "author",
				"type": "string"
			},
			{
				"name": "genre",
				"type": "string"
			},
			{
				"name": "price",
				"type": "uint256"
			},
			{
				"name": "creationTime",
				"type": "uint256"
			},
			{
				"name": "isBand",
				"type": "bool"
			},
			{
				"name": "contribution",
				"type": "uint256"
			},
			{
				"name": "totalSupply",
				"type": "uint256"
			},
			{
				"name": "phase",
				"type": "uint8"
			},
			{
				"name": "owner",
				"type": "address"
			},
			{
				"name": "contractAddress",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	}
]
