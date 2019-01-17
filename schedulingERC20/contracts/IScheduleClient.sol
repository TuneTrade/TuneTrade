pragma solidity 0.4.24;

interface IScheduleClient {
    function addScheduleCall(address receiver, uint256 delay, uint256 executionsAmount, uint256 tokensPerDelay, uint256 startScheduleLater, address token) external payable;
    function emergencyExit() external;
}
