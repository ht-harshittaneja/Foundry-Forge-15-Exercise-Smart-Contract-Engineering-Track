 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract Vault {
    address public owner;
    bool public paused = false;

    mapping(address => uint256) public balances;

    bool private locked ; //deafult value is also false

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Vault paused");
        _;
    }

    modifier nonReentrant() {
        require(!locked, "Reentrancy");
        locked = true;
        _;
        locked = false;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable whenNotPaused {
        require(msg.value > 0, "Zero deposit");

        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount)external whenNotPaused nonReentrant{
        require(amount > 0, "Zero withdrawal");
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }

    function pause() external onlyOwner {
        paused = true;
    }

    function unpause() external onlyOwner {
        paused = false;
    }
}