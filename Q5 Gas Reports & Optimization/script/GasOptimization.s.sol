// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {GasOptimizationV1} from "../src/GasOptimizationV1.sol";
import {GasOptimizationV2} from "../src/GasOptimizationV2.sol";

contract GasOptimizationScript is Script {
    GasOptimizationV1 public v1;
    GasOptimizationV2 public v2;

    function run() public {
        vm.startBroadcast();
        v1 = new GasOptimizationV1();
        v2 = new GasOptimizationV2();
        vm.stopBroadcast();
    }
}