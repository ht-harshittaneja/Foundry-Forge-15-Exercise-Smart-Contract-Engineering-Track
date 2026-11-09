// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract Crowdfunding {
    struct Campaign {
        address creator;
        uint256 goal;
        uint256 deadline;
        uint256 raised;
        bool withdrawn;
    }

    Campaign[] public campaigns;

    mapping(uint256 => mapping(address => uint256)) public contributions;

    function createCampaign(uint256 goal, uint256 duration) external {
        require(goal > 0, "Invalid goal");
        require(duration > 0, "Invalid duration");

        campaigns.push(Campaign(msg.sender, goal, block.timestamp + duration, 0, false));
    }

    function contribute(uint256 id) external payable {
        Campaign storage c = campaigns[id];

        require(block.timestamp < c.deadline, "Campaign ended");
        require(msg.value > 0, "Zero contribution");

        c.raised += msg.value;
        contributions[id][msg.sender] += msg.value;
    }

    function withdraw(uint256 id) external {
        Campaign storage c = campaigns[id];

        require(msg.sender == c.creator, "Not creator");
        require(block.timestamp >= c.deadline, "Not ended");
        require(c.raised >= c.goal, "Goal not reached");
        require(!c.withdrawn, "Already withdrawn");

        c.withdrawn = true;

        (bool success,) = payable(c.creator).call{value: c.raised}("");
        require(success, "Transfer failed");
    }

    function refund(uint256 id) external {
        Campaign storage c = campaigns[id];

        require(block.timestamp >= c.deadline, "Not ended");
        require(c.raised < c.goal, "Goal reached");

        uint256 amount = contributions[id][msg.sender];
        require(amount > 0, "Nothing to refund");

        contributions[id][msg.sender] = 0;

        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success, "Refund failed");
    }
}
