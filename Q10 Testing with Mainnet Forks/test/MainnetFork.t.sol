// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {MainnetFork} from "../src/MainnetFork.sol";

contract MainnetForkTest is Test {
    MainnetFork fork;

    function setUp() public {
        vm.createSelectFork(vm.envString("MAINNET_RPC_URL"));
        fork = new MainnetFork();
    }

    function testBorrowUSDC() public {
        deal(address(fork.weth()), address(fork), 10 ether);

        fork.borrowUSDC(10 ether, 1000e6);

        assertEq(fork.usdc().balanceOf(address(fork)), 1000e6);
    }
}
