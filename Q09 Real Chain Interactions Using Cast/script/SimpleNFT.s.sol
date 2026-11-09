// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {SimpleNFT} from "../src/SimpleNFT.sol";

contract SimpleNFTScript is Script {
    SimpleNFT public simpleNFT; 
        
    function run() public {
        vm.startBroadcast();
        simpleNFT = new SimpleNFT();
        vm.stopBroadcast();
    }
}