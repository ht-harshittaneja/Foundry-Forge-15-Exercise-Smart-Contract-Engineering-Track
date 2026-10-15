// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenScript is Script {
    MyToken public myToken ;
        
    function run() public {
        vm.startBroadcast();
        myToken = new MyToken();
        vm.stopBroadcast();
    }
}