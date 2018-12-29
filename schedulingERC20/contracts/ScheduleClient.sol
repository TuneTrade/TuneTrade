pragma solidity 0.4.24;

import './usingOraclize.sol';
import './IERC20.sol';

contract ScheduleClient is usingOraclize {
    address private _owner;
    address private _controller;

    uint256 private _id;

    uint256 private constant _gasPrice = 17500000000; // gas price is 16 gwei by default
    uint256 private constant _gasLimit = 140000;      // gas limit is 140,000 by default

    // the all hashes of schedules
    bytes32[] private _schedules;

    struct ScheduleCall {
        address receiver;
        uint256 delay;
        uint256 executed;
        uint256 executionsAmount;
        uint256 tokensPerDelay;
        uint256 startScheduleLater;
        bool canceled;
        uint256 creationDate;
        address token;
    }

    mapping(bytes32 => bytes32) private _oraclizeCallbacks;  // oraclize_query -> ScheduleCall data hash
    mapping(bytes32 => ScheduleCall) private _scheduleCalls; // ScheduleCall data hash -> ScheduleCall details

    event LogInfo(string description);
    event ScheduleCreated(bytes32 indexed data, address receiver, uint256 delay, uint256 executionsAmount, uint256 tokensPerDelay, address token);

    // -----------------------------------------
    // CONSTRUCTOR
    // -----------------------------------------

    constructor (address owner) public {
        _controller = msg.sender;
        _owner = owner;
        oraclize_setCustomGasPrice(_gasPrice);
    }

    // -----------------------------------------
    // EXTERNAL
    // -----------------------------------------

    function addScheduleCall(address receiver, uint256 delay, uint256 executionsAmount, uint256 tokensPerDelay, uint256 startScheduleLater, address token) external payable {
        require(msg.sender == _controller, "addScheduleCall: the caller is not the controller contract");
        _createSchedule(receiver, delay, executionsAmount, tokensPerDelay, startScheduleLater, token);
    }

    function cancel(bytes32 hash) external {
        require(msg.sender == _owner, 'cancel: the msg.sender is not the owner of this contract');
        ScheduleCall memory call = _scheduleCalls[hash];

        require(call.canceled == false, 'cancel: this schedule was already canceled');
        require(call.executionsAmount > call.executed, 'cancel: there are no active schedule calls');
        _checkCancelAvailability(call.creationDate, call.executed, call.delay);

        uint256 availableCalls = call.executionsAmount - call.executed;
        _scheduleCalls[hash].canceled = true;

        IERC20(call.token).transfer(_owner, availableCalls * call.tokensPerDelay);
        require(_owner.send(availableCalls * _gasLimit * _gasPrice));
    }

    function emergencyExit() external {
        require(msg.sender == _controller, 'emerganceExit: the msg.sender is not the controller contract');
        for (uint256 i = 0; i < _id; i++) {
            IERC20 _token = IERC20(_scheduleCalls[_schedules[i]].token);
            uint256 balance = _getTokenBalance(_token);
            if (balance > 0) {
                _token.transfer(_owner, balance);
            }
        }

        selfdestruct(_owner);
    }

    // -----------------------------------------
    // EXECUTION CALLBACK
    // -----------------------------------------

    function __callback(bytes32 myid, string result) public {
        require(msg.sender == oraclize_cbAddress(), "__callback: only the Oraclize registered address can execute functions");
        ScheduleCall memory call = _scheduleCalls[ _oraclizeCallbacks[myid] ];

        if(call.executionsAmount > call.executed && call.canceled == false) {
            if (_getTokenBalance(IERC20(call.token)) < call.tokensPerDelay) {
                emit LogInfo("Not enough balance");
            } else {
                // executed + 1
                _scheduleCalls[_oraclizeCallbacks[myid]].executed += 1;

                // detect the planned first schedule and miss the token transfer for that case
                if (_scheduleCalls[_oraclizeCallbacks[myid]].executed > 1 || call.startScheduleLater == 0) {
                    IERC20(call.token).transfer(call.receiver, call.tokensPerDelay);
                }

                // if there are available calls
                if(call.executionsAmount > _scheduleCalls[_oraclizeCallbacks[myid]].executed) {
                    // Generating unique query for oraclize
                    bytes32 queryId = oraclize_query(call.delay, "", "", _gasLimit);
                    _oraclizeCallbacks[queryId] = _oraclizeCallbacks[myid];
                }
            }
        }
    }

    // -----------------------------------------
    // GETTERS
    // -----------------------------------------

    function getId() external view returns (uint256) {
        return _id;
    }

    function schedules(uint256 id) external view returns (bytes32) {
        return _schedules[id];
    }

    function getScheduleDetails(bytes32 hash) external view returns (address, uint256, uint256, uint256, uint256, bool, uint256, uint256, address) {
        ScheduleCall memory call = _scheduleCalls[hash];
        return (
            call.receiver,
            call.delay,
            call.executed,
            call.executionsAmount,
            call.tokensPerDelay,
            call.canceled,
            call.creationDate,
            call.startScheduleLater,
            call.token
        );
    }

    // -----------------------------------------
    // INTERNAL
    // -----------------------------------------

    function _createSchedule(address receiver, uint256 delay, uint256 executionsAmount, uint256 tokensPerDelay, uint256 startScheduleLater, address token) internal {
        bytes32 data = _getHash(receiver, delay, executionsAmount, tokensPerDelay, startScheduleLater, token, _id);
        _id += 1;

        bool isFirstSchedulePlannedLater = startScheduleLater > 0;

        ScheduleCall memory call = ScheduleCall(
            receiver,
            delay, 0,
            isFirstSchedulePlannedLater ? executionsAmount + 1 : executionsAmount,
            tokensPerDelay,
            startScheduleLater,
            false,
            block.timestamp,
            token
        );
        _scheduleCalls[data] = call;

        uint256 queryDelay = isFirstSchedulePlannedLater ? startScheduleLater : delay;

        // Generating unique query for this schedullCall with oraclize
        bytes32 queryId = oraclize_query(queryDelay, "", "", _gasLimit);
        _oraclizeCallbacks[queryId] = data;

        _schedules.push(data);

        emit ScheduleCreated(data, receiver, delay, executionsAmount, tokensPerDelay, token);
    }

    function _getHash(address receiver, uint256 delay, uint256 executionsAmount, uint256 tokensPerDelay, uint256 startScheduleLater, address token, uint256 id) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(receiver, delay, executionsAmount, tokensPerDelay, startScheduleLater, token, id));
    }

    function _checkCancelAvailability(uint256 creationDate, uint256 executed, uint256 delay) internal view {
        require(
            block.timestamp < creationDate + ((executed + 1) * delay) - 2 minutes ||
            block.timestamp > creationDate + ((executed + 1) * delay) + 2 minutes,
            '_checkCancelAvailability: you cannot cancel schedule call +- 2 minutes from current and last scheduled call'
        );
    }

    function _getTokenBalance(IERC20 token) internal view returns (uint256) {
        return token.balanceOf(address(this));
    }

    // -----------------------------------------
    // FALLBACK
    // -----------------------------------------

    function () public payable {
        // ETH claimed
    }
}
