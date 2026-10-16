// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {Voting} from "../src/Voting.sol";

contract VotingScript is Script {
    Voting public voting ;
        
    function run() public {
        vm.startBroadcast();
        voting = new Voting();
        vm.stopBroadcast();
    }
}