smartContract =[
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
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
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
				"name": "_minpresale",
				"type": "uint256"
			},
			{
				"name": "_minMainSale",
				"type": "uint256"
			},
			{
				"name": "_maxEth",
				"type": "uint256"
			},
			{
				"name": "_maxCap",
				"type": "uint256"
			},
			{
				"name": "_minCap",
				"type": "uint256"
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
			}
		],
		"name": "AddICO",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
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
				"name": "_ico",
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
	}
]
