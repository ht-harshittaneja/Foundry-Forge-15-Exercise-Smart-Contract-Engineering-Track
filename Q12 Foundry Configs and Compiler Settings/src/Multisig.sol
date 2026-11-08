// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract Multisig {
    address[] public owners;
    uint256 public threshold;

    struct Transaction {
        address to;
        uint256 value;
        bool executed;
        uint256 approvalCount;
    }

    Transaction[] public transactions;

    mapping(uint256 => mapping(address => bool)) public approvals;

    modifier onlyOwner() {
        require(isOwner(msg.sender), "Not an owner");
        _;
    }

    constructor(address alice, address bob, address charlie) {
        require(alice != address(0), "Invalid Alice");
        require(bob != address(0), "Invalid Bob");
        require(charlie != address(0), "Invalid Charlie");

        require(alice != bob && bob != charlie && alice != charlie, "Duplicate owners");

        owners.push(alice);
        owners.push(bob);
        owners.push(charlie);

        threshold = 2;
    }

    function isOwner(address account) public view returns (bool) {
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == account) {
                return true;
            }
        }
        return false;
    }

    function submitTransaction(address to, uint256 value) external onlyOwner {
        transactions.push(Transaction({to: to, value: value, executed: false, approvalCount: 0}));
    }

    function approveTransaction(uint256 txIndex) external onlyOwner {
        require(txIndex < transactions.length, "Invalid transaction");
        require(!transactions[txIndex].executed, "Already executed");
        require(!approvals[txIndex][msg.sender], "Already approved");

        approvals[txIndex][msg.sender] = true;
        transactions[txIndex].approvalCount++;

        if (transactions[txIndex].approvalCount >= threshold) {
            executeTransaction(txIndex);
        }
    }

    function executeTransaction(uint256 txIndex) public onlyOwner {
        require(txIndex < transactions.length, "Invalid transaction");

        Transaction storage txn = transactions[txIndex];

        require(!txn.executed, "Already executed");
        require(txn.approvalCount >= threshold, "Not enough approvals");

        txn.executed = true;

        (bool success,) = txn.to.call{value: txn.value}("");

        require(success, "Execution failed");
    }

    function getTransactionCount() external view returns (uint256) {
        return transactions.length;
    }
}
