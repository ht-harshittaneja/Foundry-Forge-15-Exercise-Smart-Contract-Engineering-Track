// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract GasOptimizationV1 {
    uint256 public constant GRANT = 1 ether;
    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    function getEth(address payable user) public {
        require(msg.sender == owner, "Not owner");
        require(user != address(0), "Invalid recipient");
        require(address(this).balance >= GRANT , "Insufficient Funds");

        (bool success, ) = user.call{value:GRANT}("");
        require(success, "Transfer failed");
    }
}