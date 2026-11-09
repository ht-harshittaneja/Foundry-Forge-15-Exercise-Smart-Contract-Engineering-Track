// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {Crowdfunding} from "../src/Crowdfunding.sol";

contract CrowdfundingScript is Script {
    Crowdfunding public cf;

    function run() external {
        vm.startBroadcast();
        cf = new Crowdfunding();
        vm.stopBroadcast();
    }
}
