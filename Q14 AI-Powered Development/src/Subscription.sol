// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract Subscription {
    uint256 public constant MONTH = 30 days;
    uint256 public constant PRICE = 0.01 ether;

    mapping(address => uint256) public subscriptionExpiry;

    function subscribe() external payable {
        require(msg.value == PRICE, "Incorrect payment");

        uint256 currentExpiry = subscriptionExpiry[msg.sender];

        if (currentExpiry > block.timestamp) {
            subscriptionExpiry[msg.sender] = currentExpiry + MONTH;
        } else {
            subscriptionExpiry[msg.sender] = block.timestamp + MONTH;
        }
    }

    function isSubscribed(address user) external view returns (bool) {
        return subscriptionExpiry[user] > block.timestamp;
    }
}