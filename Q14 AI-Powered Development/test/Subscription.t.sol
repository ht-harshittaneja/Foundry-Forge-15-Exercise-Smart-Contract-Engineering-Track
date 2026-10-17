// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {Subscription} from "../src/Subscription.sol";

contract SubscriptionTest is Test {
    Subscription public subscription;

    address public alice = address(1);

    function setUp() public {
        subscription = new Subscription();
        vm.deal(alice, 1 ether);
    }

    function testSubscribe() public {
        vm.prank(alice);

        subscription.subscribe{value: 0.01 ether}();
        assertTrue(subscription.isSubscribed(alice));
    }

    function testSubscriptionExpiresAfterOneMonth() public {
        vm.prank(alice);
        subscription.subscribe{value: 0.01 ether}();

        vm.warp(block.timestamp + 30 days);
        assertFalse(subscription.isSubscribed(alice));
    }

    function testRenewSubscription() public {
        vm.prank(alice);
        subscription.subscribe{value: 0.01 ether}();

        uint256 firstExpiry = subscription.subscriptionExpiry(alice);

        vm.prank(alice);
        subscription.subscribe{value: 0.01 ether}();
        assertEq(subscription.subscriptionExpiry(alice),firstExpiry + 30 days);
    }

    function testCannotSubscribeWithWrongPayment() public {
        vm.prank(alice);

        vm.expectRevert("Incorrect payment");
        subscription.subscribe{value: 0.005 ether}();
    }
}