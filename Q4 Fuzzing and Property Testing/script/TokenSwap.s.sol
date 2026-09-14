// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {TokenSwap} from "../src/TokenSwap.sol";

contract TokenSwapScript is Script {
    TokenSwap public tokenSwap ;
        
    function run() public {
        vm.startBroadcast();
        tokenSwap = new TokenSwap();
        vm.stopBroadcast();
    }
}