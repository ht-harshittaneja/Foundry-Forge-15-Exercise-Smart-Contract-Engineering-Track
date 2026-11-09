// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {Crowdfunding} from "../src/Crowdfunding.sol";

contract CrowdfundingTest is Test {
    Crowdfunding cf;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        cf = new Crowdfunding();
        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);
    }

    function testCreateCampaign() public {
        cf.createCampaign(5 ether, 7 days);

        (address creator, uint256 goal,,,) = cf.campaigns(0);

        assertEq(creator, address(this));
        assertEq(goal, 5 ether);
    }

    function testContribution() public {
        cf.createCampaign(5 ether, 7 days);

        vm.prank(alice);
        cf.contribute{value: 2 ether}(0);

        assertEq(cf.contributions(0, alice), 2 ether);
    }

    function testSuccessfulWithdrawal() public {
        cf.createCampaign(5 ether, 1 days);

        vm.prank(alice);
        cf.contribute{value: 5 ether}(0);

        vm.warp(block.timestamp + 1 days);

        uint256 beforeBalance = address(this).balance;

        cf.withdraw(0);

        assertEq(address(this).balance, beforeBalance + 5 ether);
    }

    function testRefundAfterFailedCampaign() public {
        cf.createCampaign(5 ether, 1 days);

        vm.prank(alice);
        cf.contribute{value: 2 ether}(0);

        vm.warp(block.timestamp + 1 days);

        uint256 beforeBalance = alice.balance;

        vm.prank(alice);
        cf.refund(0);

        assertEq(alice.balance, beforeBalance + 2 ether);
    }

    function testCannotContributeAfterDeadline() public {
        cf.createCampaign(5 ether, 1 days);

        vm.warp(block.timestamp + 1 days);

        vm.expectRevert("Campaign ended");
        cf.contribute{value: 1 ether}(0);
    }

    function testCannotWithdrawBeforeDeadline() public {
        cf.createCampaign(5 ether, 1 days);

        vm.prank(alice);
        cf.contribute{value: 5 ether}(0);

        vm.expectRevert("Not ended");
        cf.withdraw(0);
    }

    function testCannotWithdrawIfGoalNotReached() public {
        cf.createCampaign(5 ether, 1 days);

        vm.prank(alice);
        cf.contribute{value: 2 ether}(0);

        vm.warp(block.timestamp + 1 days);

        vm.expectRevert("Goal not reached");
        cf.withdraw(0);
    }
    receive() external payable {}
}
