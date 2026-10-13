// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {GasOptimizationV1} from "../src/GasOptimizationV1.sol";
import {GasOptimizationV2} from "../src/GasOptimizationV2.sol";

contract GasOptimizationTest is Test {
    GasOptimizationV1 public v1;
    GasOptimizationV2 public v2;

    address payable user1 = payable(address(0x101));
    address payable user2 = payable(address(0x102));
    address payable user3 = payable(address(0x103));

    function setUp() public {
        v1 = new GasOptimizationV1();
        v2 = new GasOptimizationV2();

        vm.deal(address(v1), 3 ether);
        vm.deal(address(v2), 3 ether);
    }

    // V1: Individual payments
    function testPayIndividually() public {
        v1.getEth(user1);
        v1.getEth(user2);
        v1.getEth(user3);

        assertEq(user1.balance, 1 ether);
        assertEq(user2.balance, 1 ether);
        assertEq(user3.balance, 1 ether);
        assertEq(address(v1).balance, 0);
    }

    // V2: Batch payments
    function testBatchDistribution() public {
        address payable[] memory users = new address payable[](3);
        users[0] = user1;
        users[1] = user2;
        users[2] = user3;

        v2.distribute(users);

        assertEq(user1.balance, 1 ether);
        assertEq(user2.balance, 1 ether);
        assertEq(user3.balance, 1 ether);
        assertEq(address(v2).balance, 0);
    }
}