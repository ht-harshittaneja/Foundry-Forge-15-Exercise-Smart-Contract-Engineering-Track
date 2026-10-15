// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {Auction} from "../src/Auction.sol";

contract AuctionTest is Test {
    Auction auction;

    address alice;
    address bob;

    event BidPlaced(address indexed bidder, uint amount);

    function setUp() public {
        auction = new Auction();

        alice = makeAddr("alice");
        bob = makeAddr("bob");

        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);
    }

    function testBid() public {
        vm.prank(alice);
        auction.bid{value: 1 ether}();

        assertEq(auction.highestBid(), 1 ether);
        assertEq(auction.highestBidder(), alice);
    }

    function testBidEmitsEvent() public {
        vm.expectEmit(true, false, false, true, address(auction));
        emit BidPlaced(alice, 1 ether);

        vm.prank(alice);
        auction.bid{value: 1 ether}();
    }

    function testBidBeforeDeadline() public {
        vm.warp(auction.deadline() - 1);

        vm.prank(alice);
        auction.bid{value: 1 ether}();

        assertEq(auction.highestBid(), 1 ether);
    }

    function testRevertAfterDeadline() public {
        vm.warp(auction.deadline());

        vm.expectRevert("Auction ended");
        vm.prank(alice);
        auction.bid{value: 1 ether}();
    }

    function testRevertIfBidTooLow() public {
        vm.prank(alice);
        auction.bid{value: 1 ether}();

        vm.expectRevert("Bid too low");
        vm.prank(bob);
        auction.bid{value: 0.5 ether}();
    }
}