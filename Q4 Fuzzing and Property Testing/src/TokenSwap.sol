// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
}

contract TokenSwap {
    IERC20 public tokenA;
    IERC20 public tokenB;

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function swapAToB(uint256 amount) public {
        require(amount > 0, "Invalid amount");

        bool s1 = tokenA.transferFrom(msg.sender, address(this), amount);
        require(s1, "Transfer failed");
        bool s2 = tokenB.transfer(msg.sender, amount);
        require(s2, "Transfer failed");
    }

    function swapBToA(uint256 amount) public {
        require(amount > 0, "Invalid amount");

        bool s1 = tokenB.transferFrom(msg.sender, address(this), amount);
        require(s1, "Transfer failed");
        bool s2 = tokenA.transfer(msg.sender, amount);
        require(s2, "Transfer failed");
    }
}