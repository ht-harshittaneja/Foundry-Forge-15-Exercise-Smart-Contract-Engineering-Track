// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {Auction} from "../src/Auction.sol";

contract AuctionScript is Script {
    Auction public auction ;
        
    function run() public {
        vm.startBroadcast();
        auction = new Auction(); 
        vm.stopBroadcast();
    }
}