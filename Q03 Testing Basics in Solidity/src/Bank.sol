// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract Bank {
    mapping(address => uint256) balances;
    event Deposit(uint256 indexed time ,address indexed _adr ,uint256 amount);
    event Withdraw (uint256 indexed time ,address indexed _adr ,uint256 amount);

    function getBalance() public view returns(uint256) {
        return balances[msg.sender];
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit must be greater than zero");
        balances[msg.sender] += msg.value;
        emit Deposit(block.timestamp, msg.sender, msg.value);
    } 

    function withdraw(uint256 _amount) public{ //here _amount is in wei
        require(_amount > 0, "Amount must be greater than zero");
        require(balances[msg.sender] >= _amount , "Insuficient Balance");
        balances[msg.sender]-=_amount;
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Transfer failed");
        emit Withdraw(block.timestamp, msg.sender,_amount);
    }
}