// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {ERC20} from "../src/ERC20.sol";
import {TokenSwap} from "../src/TokenSwap.sol";

contract TokenSwapInvariantTest is Test {
    ERC20 tokenA;
    ERC20 tokenB;
    TokenSwap tokenSwap;

    address alice = makeAddr("alice");
    uint256 constant LIQUIDITY = 1_000e18;
    uint256 constant ALICE_BALANCE = 1_000e18;

    function setUp() public {
        tokenA = new ERC20();
        tokenB = new ERC20();
        tokenSwap = new TokenSwap(address(tokenA), address(tokenB));

        tokenA.mint(address(tokenSwap), LIQUIDITY);
        tokenB.mint(address(tokenSwap), LIQUIDITY);

        tokenA.mint(alice, ALICE_BALANCE);
        vm.prank(alice);
        tokenA.approve(address(tokenSwap), type(uint256).max);

        targetContract(address(tokenSwap));   // random calls go only to TokenSwap
        targetSender(alice);                  // random calls come only from alice
    }

    function invariant_PoolValueConserved() public view {
        uint256 poolTotal = tokenA.balanceOf(address(tokenSwap))+ tokenB.balanceOf(address(tokenSwap));
        assertEq(poolTotal, 2 * LIQUIDITY);
    }
}