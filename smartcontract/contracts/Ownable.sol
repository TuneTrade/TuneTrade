pragma solidity ^0.4.24;


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
