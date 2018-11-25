pragma solidity ^0.4.24;

import "./Ownable.sol";
import "./TTPositionManager.sol";


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