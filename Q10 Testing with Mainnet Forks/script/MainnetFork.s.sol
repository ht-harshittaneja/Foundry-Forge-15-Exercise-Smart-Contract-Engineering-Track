// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {MainnetFork} from "../src/MainnetFork.sol";

contract MainnetForkScript is Script {
    MainnetFork public fork ;

    function run() public {
        vm.startBroadcast();
        fork = new MainnetFork();
        vm.stopBroadcast();
    }
}
