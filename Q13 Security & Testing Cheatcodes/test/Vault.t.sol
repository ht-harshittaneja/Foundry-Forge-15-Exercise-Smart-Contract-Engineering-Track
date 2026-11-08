
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";

contract VaultTest is Test {
    Vault public vault;

    address public alice = address(1);
    address public bob = address(2);

    function setUp() public {
        vault = new Vault();

        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);
    }

    function testDeposit() public {
        vm.prank(alice);
        vault.deposit{value: 1 ether}();

        assertEq(vault.balances(alice), 1 ether);
        assertEq(address(vault).balance, 1 ether);
    }

    function testWithdraw() public {
        vm.prank(alice);
        vault.deposit{value: 2 ether}();

        vm.prank(alice);
        vault.withdraw(1 ether);

        assertEq(vault.balances(alice), 1 ether);
        assertEq(alice.balance, 9 ether);
    }

    function testOnlyOwnerCanPause() public {
        vm.prank(bob);
        vm.expectRevert("Not owner");
        vault.pause();
    }

    function testOwnerCanPause() public {
        vault.pause();

        assertTrue(vault.paused());
    }

    function testCannotDepositWhenPaused() public {
        vault.pause();

        vm.prank(alice);
        vm.expectRevert("Vault paused");
        vault.deposit{value: 1 ether}();
    }

    function testCannotWithdrawWhenPaused() public {
        vm.prank(alice);
        vault.deposit{value: 1 ether}();

        vault.pause();

        vm.prank(alice);
        vm.expectRevert("Vault paused");
        vault.withdraw(1 ether);
    }

    function testOwnerCanUnpause() public {
        vault.pause();
        vault.unpause();

        assertFalse(vault.paused());
    }

    function testCannotWithdrawMoreThanBalance() public {
        vm.prank(alice);
        vault.deposit{value: 1 ether}();

        vm.prank(alice);
        vm.expectRevert("Insufficient balance");
        vault.withdraw(2 ether);
    }

    function testCannotDepositZero() public {
        vm.prank(alice);
        vm.expectRevert("Zero deposit");
        vault.deposit{value: 0}();
    }

    function testCannotWithdrawZero() public {
        vm.prank(alice);
        vm.expectRevert("Zero withdrawal");
        vault.withdraw(0);
    }
}