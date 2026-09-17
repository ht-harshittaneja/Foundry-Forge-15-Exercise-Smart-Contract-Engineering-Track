// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {ERC20} from "../src/ERC20.sol";
import {TokenSwap} from "../src/TokenSwap.sol";

contract TokenSwapTest is Test {
    ERC20 tokenA;
    ERC20 tokenB;
    TokenSwap tokenSwap;

    address alice = makeAddr("alice");
    uint256 constant LIQUIDITY = 1_000e18;
    uint256 constant ALICE_BALANCE = 1_000e18;   // alice's initial A

    function setUp() public {
        tokenA = new ERC20();
        tokenB = new ERC20();
        tokenSwap = new TokenSwap(address(tokenA), address(tokenB));

        //Pool liquidity: the swap must hold tokens to pay out
        tokenA.mint(address(tokenSwap), LIQUIDITY);
        tokenB.mint(address(tokenSwap), LIQUIDITY);

        //alice holds A and approves the swap to pull it
        tokenA.mint(alice, ALICE_BALANCE);
        vm.prank(alice);
        tokenA.approve(address(tokenSwap), type(uint256).max);
    }

    function test_RevertWhenZeroSwapAToB() public {
        vm.expectRevert("Amount must be greater than zero");
        tokenSwap.swapAToB(0);
    }

    function testFuzz_SwapAToB(uint256 amount) public {
        amount = bound(amount, 1, ALICE_BALANCE);

        vm.prank(alice);
        tokenSwap.swapAToB(amount);

        assertEq(tokenA.balanceOf(alice), ALICE_BALANCE - amount);
        assertEq(tokenB.balanceOf(alice), amount);
        assertEq(tokenA.balanceOf(address(tokenSwap)), LIQUIDITY + amount);
        assertEq(tokenB.balanceOf(address(tokenSwap)), LIQUIDITY - amount);
    }

    function testFuzz_SwapAToB_AnyUser(address user, uint256 amount) public {
        vm.assume(user != address(0));
        vm.assume(user != address(tokenSwap));
        amount = bound(amount, 1, LIQUIDITY);

        tokenA.mint(user, amount);
        vm.startPrank(user);
        tokenA.approve(address(tokenSwap), amount);
        tokenSwap.swapAToB(amount);
        vm.stopPrank();

        assertEq(tokenB.balanceOf(user), amount);
    }
}