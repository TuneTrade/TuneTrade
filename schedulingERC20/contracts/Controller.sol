pragma solidity 0.4.24;

import "./ScheduleClient.sol";
import "./IScheduleClient.sol";

contract Controller {
    address private _owner;

    uint256 private _fee = 0;                         // fee for using a service in wei
    uint256 private constant _gasPrice = 17500000000; // gas price is 16 gwei by default
    uint256 private constant _gasLimit = 140000;      // gas limit is 140,000 by default

    mapping(address => address) private _clientAccount; // User address - > Contract address

    event ScheduleCallEvent(address owner, address receiver, uint256 delay, uint256 executionsAmount, uint256 tokensPerDelay, uint startScheduleLater, address token);

    // -----------------------------------------
    // CONSTRUCTOR
    // -----------------------------------------

    constructor () public {
        _owner = msg.sender;
    }

    // -----------------------------------------
    // EXTERNAL
    // -----------------------------------------

    function scheduleCall(address receiver, uint256 delay, uint256 executionsAmount, uint256 tokensPerDelay, uint256 startScheduleLater, address token) public payable returns (address) {
        _preValidation(receiver, delay, executionsAmount, tokensPerDelay, startScheduleLater, token);
        _createAccount();

        // Distribution of fee and amount for scheduled execution
        _owner.transfer(_fee);
        IScheduleClient(_clientAccount[msg.sender]).addScheduleCall.value(msg.value - _fee)(receiver, delay, executionsAmount, tokensPerDelay, startScheduleLater, token);

        emit ScheduleCallEvent(msg.sender, receiver, delay, executionsAmount, tokensPerDelay, startScheduleLater, token);
        return _clientAccount[msg.sender];
    }

    function deleteAccount() external {
        _deleteAccount(msg.sender);
    }

    function changeFee(uint256 newFee) external {
        require(msg.sender == _owner, "changeFee: only owner can change the fee");
        _fee = newFee;
    }

    function transferOwnership(address newOwner) external {
        require(msg.sender == _owner);
        require(newOwner != address(0), "transferOwnership: the address of the new owner is not valid");
        _owner = newOwner;
    }

    // -----------------------------------------
    // INTERNAL
    // -----------------------------------------

    function getFee() external view returns (uint256) {
        return _fee;
    }

    function isOwner(address user) external view returns (bool) {
        return user == _owner;
    }

    function getUserContractAddress(address user) external view returns (address) {
        return _clientAccount[user];
    }

    // -----------------------------------------
    // INTERNAL
    // -----------------------------------------

    function _preValidation(address receiver, uint256 delay, uint256 executionsAmount, uint256 tokensPerDelay, uint256 startScheduleLater, address token) internal view {
        if (startScheduleLater > 0) {
            require(msg.value == (_gasLimit * _gasPrice * (executionsAmount + 1)) + _fee, "_preValidation: msg.value is not enough for making schedule calls");
        } else {
            require(msg.value == (_gasLimit * _gasPrice * executionsAmount) + _fee, "_preValidation: msg.value is not enough for making schedule calls");
        }
        require(token != address(0),"_preValidation: not valid token address");
        require(receiver != address(0), "_preValidation: the receiver address is not valid");
        require(delay > 0, "_preValidation: the delay is not bigger than 0");
        require(executionsAmount > 0, "_preValidation: the executions amount is not bigger than 0");
        require(tokensPerDelay > 0, "_preValidation: tokens per delay is not bigger than 0");
    }

    function _createAccount() internal {
        if (_clientAccount[msg.sender] == address(0)) {
            ScheduleClient newContract = new ScheduleClient(msg.sender);
            _clientAccount[msg.sender] = address(newContract);
        }
    }

    function _deleteAccount(address user) internal {
        IScheduleClient(_clientAccount[msg.sender]).emergencyExit();
        delete _clientAccount[user];
    }
}
