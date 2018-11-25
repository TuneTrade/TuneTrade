pragma solidity ^0.4.24;

// File: contracts\Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "Access restricted to owner only");
    _;
  }


  function transferOwnership(address _newOwner) public {
    require(_newOwner != address(0));
    owner = _newOwner;
  }
}

// File: contracts\TTPositionManager.sol

interface Exchange 
{
    function TerminatePosition(bool closedOrCancelled) external;
}

interface TokenContract 
{
    function balanceOf(address who) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
}

contract TTPositionManager is Ownable {

    event ReceivedPayment(uint256 weiAmount, address from);
    event ReceivedTokens(uint256 tokenAmount, address tokenOwner, address from);
    event PositionCancelled();
    event PositionClosed();

    address token;
    uint256 volume;
    bool buySell; //true - Buy, false - Sell
    uint256 created;
    uint256 cost;
    address tokenReceiver;
    address tokenSender;
    address tokenExchange;

        // TTPositionManager manager = new TTPositionManager(token, volume, BuySell, now, cost, msg.sender);

    function tokenFallback(address _tokenSender, uint _value, bytes _data) public {
        require(msg.sender == token, "Tokens can be accepted only from designated token conract"); 
        uint256 balance = TokenContract(token).balanceOf(this);
        require(balance == volume, "Contract only accepts exact token amount equal to volume");
        
        if (buySell == true ) {
            require (address(this).balance == cost, "ETH to buy tokens must be already transfered to the contract");
            tokenSender = _tokenSender;
            TokenContract(token).transfer(owner,volume);
            tokenSender.transfer(cost);
            emit PositionClosed();
            emit ReceivedTokens(balance, _tokenSender, msg.sender);
            RemoveFromExchange();
        } else {
            emit ReceivedTokens(balance, _tokenSender, msg.sender);
        }

    }

    function BuyTokens() public payable {
        require(buySell == false, "You can buy tokens only from selling positions" );
        require(TokenContract(token).balanceOf(address(this)) == volume, "Tokens must be already transfered");
        require (msg.value == cost, "You must send exact amount of ETH to buy tokens");
        tokenReceiver = msg.sender;
        TokenContract(token).transfer(msg.sender,volume);
        owner.transfer(msg.value);
        RemoveFromExchange();
        emit ReceivedPayment(msg.value, msg.sender);
        emit PositionClosed();
    }
    
    constructor(address _token, uint256 _volume, bool _buySell, uint256 _cost, address _owner) public payable {
        require(_buySell == false || msg.value == _cost,"Buying positions must be created with ETH");
        token = _token;
        volume = _volume; 
        buySell = _buySell;
        cost = _cost;
        owner = _owner;
        created = block.timestamp;
        tokenExchange = msg.sender;

    }
    function RemoveFromExchange() internal  
    {
        Exchange(tokenExchange).TerminatePosition(true);
        suicide(owner); //send available funds to the owner
    }

    function CancelPosition() public onlyOwner {
        uint256 balance  = TokenContract(token).balanceOf(this);
        if (buySell == true) { //buyig position. we have to send ETHEREUM back to the owner. 
        //the question is what to do when by any chance there are tokens from token contract on this position. 
        // We send it to Token Exchange Contract for manual action to be taken. 
            if (balance > 0) {
                TokenContract(token).transfer(tokenExchange, balance);
            }

        } else { //this is sell position. Send back all tokens to the owner.
            TokenContract(token).transfer(owner, balance);
        }
        
        emit PositionCancelled();
        Exchange(tokenExchange).TerminatePosition(false);      
        selfdestruct(owner);
    }

    

    function GetPositionData() public view returns (
        address _token, 
        uint256 _volume, 
        bool _buySell, 
        uint256 _created, 
        uint256 _cost, 
        address _customer, 
        address _managerAddress,
        bool    _active,
        uint256 _tokenBalance,
        uint256 _weiBalance
        ) 
    {
        bool active;
        uint256 weiBalance = address(this).balance;
        uint256 tokenBalance = TokenContract(token).balanceOf(this);
        if (buySell == true) {  // this a position when somebody wants to buy tokens. They have to send ETH to make it happen.
            if ( weiBalance >= cost) active = true;
            else active = false;
        } else {    // this is a position when somebody wants to sell tokens. 
            if ( tokenBalance >= volume) active = true;
            else active = false;

        }
        return (token, volume, buySell, created, cost, owner, this, active, tokenBalance, weiBalance);
    }


}

// File: contracts\TuneTraderExchange.sol

contract TuneTraderExchange is Ownable
{
    event ReceivedTokens(uint256 volume, address tokenSender, address tokenAddress);
    event NewPosition(address token, uint256 volume, bool buySell, uint256 cost, address owner);
    event PositionClosed(address indexed position);
    event PositionCancelled(address indexed position);
    mapping (address => bool) positionExist;
    address[] positionsAddresses;
    mapping (address => uint256) positionIndex;

    function AddPosition(address token, uint256 volume, bool buySell, uint256 cost) public payable 
    {
        require(buySell == false || msg.value == cost, "Buying positions must be created with ETH");
        
        TTPositionManager manager = (new TTPositionManager).value(msg.value)(token, volume, buySell, cost, msg.sender);
        // Position memory newPosition =  Position(token, volume, BuySell, now, cost, msg.sender, address(manager));
        positionsAddresses.push(manager);
        positionExist[address(manager)] = true;
        positionIndex[address(manager)] = positionsAddresses.length - 1; 
        emit NewPosition(token, volume, buySell, cost, msg.sender);
    }

    // function PositionsCount () public view returns (uint256) {
    //     return positionsAddresses.length;
    // }

    function GetPositions () public view returns (address[]) {
        return positionsAddresses;
    }


    function tokenFallback(address _tokenSender, uint _value, bytes _data) public {
        emit ReceivedTokens(_value, _tokenSender, msg.sender);
    }



    function TerminatePosition(bool closedOrCancelled) external {
        require (positionExist[msg.sender], "Position must exist on the list");
        uint256 index = positionIndex[msg.sender];
        uint256 maxIndex = positionsAddresses.length - 1;

        if (index < maxIndex) {
            positionIndex[positionsAddresses[maxIndex]] = index;
            positionsAddresses[index] = positionsAddresses[maxIndex];
        }
        delete positionsAddresses[maxIndex];
        delete positionIndex[msg.sender];
        delete positionExist[msg.sender];
        positionsAddresses.length = positionsAddresses.length - 1;

        if (closedOrCancelled == true ) {
            emit PositionClosed(msg.sender);
        } else {
            emit PositionCancelled(msg.sender);
        }
        
    }



}
