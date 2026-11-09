// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {Greeting} from "../src/Greeting.sol";

contract GreetingScript is Script {
    Greeting public greeting;

    function run() public {
        vm.startBroadcast();
        greeting = new Greeting();
        vm.stopBroadcast();
    }
}