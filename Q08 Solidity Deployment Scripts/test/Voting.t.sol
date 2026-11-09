// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {Voting} from "../src/Voting.sol";

contract VotingTest is Test {
    Voting public voting;

    address public alice = address(1);
    address public bob = address(2);

    function setUp() public {
        voting = new Voting();
    }

    function testInitialProposals() public view {
        assertEq(voting.proposals(1), "XYZ");
        assertEq(voting.proposals(2), "BJP");
        assertEq(voting.proposals(3), "ABC");
    }

    function testAddProposal() public  {
        voting.addProposal("DEF");

        assertEq(voting.proposals(4), "DEF");
    }

    function testVote() public {
        vm.prank(alice);

        voting.digitalVotingBooth(1);

        assertEq(voting.voteCount(1), 1);
    }

    function testMultipleVotesForSameProposal() public {
        vm.prank(alice);
        voting.digitalVotingBooth(1);

        vm.prank(bob);
        voting.digitalVotingBooth(1);

        assertEq(voting.voteCount(1), 2);
    }

    function testCannotVoteTwice() public {
        vm.prank(alice);
        voting.digitalVotingBooth(1);

        vm.expectRevert("Already voted");
        vm.prank(alice);
        voting.digitalVotingBooth(2);
    }

    function testCannotVoteForInvalidProposal() public {
        vm.prank(alice);

        vm.expectRevert("NOT A VALID CANDIDATE");
        voting.digitalVotingBooth(4);
    }
}