// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./ERC20.sol";

contract TokenSwap {
    ERC20 public tokenA;
    ERC20 public tokenB;

    constructor(address _tokenA, address _tokenB) {
        tokenA = ERC20(_tokenA);
        tokenB = ERC20(_tokenB);
    }

    function swapAToB(uint256 amount) public {
        require(amount > 0, "Amount must be greater than zero");

        bool s1 = tokenA.transferFrom(msg.sender, address(this), amount);
        require(s1, "Transfer failed");
        bool s2 = tokenB.transfer(msg.sender, amount);
        require(s2, "Transfer failed");
    }
}