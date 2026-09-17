// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {ERC20} from "../src/ERC20.sol";
import {TokenSwap} from "../src/TokenSwap.sol";

contract TokenSwapScript is Script {
    ERC20 tokenA;
    ERC20 tokenB;
    TokenSwap public tokenSwap ;
        
    function run() public {
        vm.startBroadcast();
        tokenA = new ERC20();
        tokenB = new ERC20();
        tokenSwap = new TokenSwap(address(tokenA),address(tokenB));
        tokenA.mint(address(tokenSwap), 1_000_000e18);
        tokenB.mint(address(tokenSwap), 1_000_000e18);
        vm.stopBroadcast();
    }
}