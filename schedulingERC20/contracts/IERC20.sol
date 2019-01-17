pragma solidity 0.4.24;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address who) external view returns (uint256);
    function name() external view returns (string);
    function symbol() external view returns (string);
    function decimals() external view returns (uint256);
}
