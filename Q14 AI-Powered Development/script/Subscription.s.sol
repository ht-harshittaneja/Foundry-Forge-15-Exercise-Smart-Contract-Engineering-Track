// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {Subscription} from "../src/Subscription.sol";

contract SubscriptionScript is Script {
    Subscription public subscription;
    function run() public {
        vm.startBroadcast();
        subscription = new Subscription();
        vm.stopBroadcast();
    }
}