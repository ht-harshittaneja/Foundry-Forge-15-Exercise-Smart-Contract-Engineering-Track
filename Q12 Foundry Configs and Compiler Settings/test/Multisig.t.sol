// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {Multisig} from "../src/Multisig.sol";

contract MultisigTest is Test {
    Multisig public wallet;

    address public alice = address(1);
    address public bob = address(2);
    address public charlie = address(3);
    address public receiver = address(4);

    function setUp() public {
        wallet = new Multisig(alice, bob, charlie);

        // Fund the multisig wallet with 10 ETH
        vm.deal(address(wallet), 10 ether);
        assertEq(address(wallet).balance, 10 ether);
    }

    function testOwners() public view {
        assertTrue(wallet.isOwner(alice));
        assertTrue(wallet.isOwner(bob));
        assertTrue(wallet.isOwner(charlie));

        assertFalse(wallet.isOwner(receiver));
    }

    function testSubmitTransaction() public {
        vm.prank(alice);
        wallet.submitTransaction(receiver, 1 ether);

        assertEq(wallet.getTransactionCount(), 1);

        (address to, uint256 value, bool executed, uint256 approvalCount) = wallet.transactions(0);

        assertEq(to, receiver);
        assertEq(value, 1 ether);
        assertFalse(executed);
        assertEq(approvalCount, 0);
    }

    function testApproveTransaction() public {
        vm.prank(alice);
        wallet.submitTransaction(receiver, 1 ether);

        vm.prank(alice);
        wallet.approveTransaction(0);

        assertTrue(wallet.approvals(0, alice));

        (,, bool executed, uint256 approvalCount) = wallet.transactions(0);

        assertFalse(executed);
        assertEq(approvalCount, 1);
    }

    function testAutomaticExecutionAfterTwoApprovals() public {
        uint256 walletBefore = address(wallet).balance;
        uint256 receiverBefore = receiver.balance;

        vm.prank(alice);
        wallet.submitTransaction(receiver, 1 ether);

        vm.prank(alice);
        wallet.approveTransaction(0);

        vm.prank(bob);
        wallet.approveTransaction(0);

        (,, bool executed, uint256 approvalCount) = wallet.transactions(0);

        assertTrue(executed);
        assertEq(approvalCount, 2);

        assertEq(address(wallet).balance, walletBefore - 1 ether);
        assertEq(receiver.balance, receiverBefore + 1 ether);
    }

    function testCannotApproveTwice() public {
        vm.prank(alice);
        wallet.submitTransaction(receiver, 1 ether);

        vm.prank(alice);
        wallet.approveTransaction(0);

        vm.prank(alice);
        vm.expectRevert("Already approved");
        wallet.approveTransaction(0);
    }

    function testCannotApproveInvalidTransaction() public {
        vm.prank(alice);
        vm.expectRevert("Invalid transaction");
        wallet.approveTransaction(0);
    }

    function testNonOwnerCannotSubmit() public {
        vm.prank(receiver);
        vm.expectRevert("Not an owner");
        wallet.submitTransaction(receiver, 1 ether);
    }

    function testNonOwnerCannotApprove() public {
        vm.prank(alice);
        wallet.submitTransaction(receiver, 1 ether);

        vm.prank(receiver);
        vm.expectRevert("Not an owner");
        wallet.approveTransaction(0);
    }

    function testCannotExecuteWithoutThreshold() public {
        vm.prank(alice);
        wallet.submitTransaction(receiver, 1 ether);

        vm.prank(alice);
        vm.expectRevert("Not enough approvals");
        wallet.executeTransaction(0);
    }
}
