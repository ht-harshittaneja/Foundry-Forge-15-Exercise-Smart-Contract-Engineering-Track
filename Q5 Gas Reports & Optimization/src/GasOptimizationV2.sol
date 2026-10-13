
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract GasOptimizationV2 {
    uint256 public constant GRANT = 1 ether;
    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    function distribute(address payable[] calldata users) external {
        require(msg.sender == owner, "Not owner");

        uint256 total = users.length * GRANT;
        require(address(this).balance >= total, "Insufficient funds");

        for (uint256 i = 0; i < users.length; i++) {
            require(users[i] != address(0), "Invalid recipient");
            (bool success, ) = users[i].call{value: GRANT}("");
            require(success, "Transfer failed");
        }
    }

    receive() external payable {}
}
