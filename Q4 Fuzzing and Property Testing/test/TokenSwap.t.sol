// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {TokenSwap} from "../src/TokenSwap.sol";

contract TokenSwapTest is Test {
    TokenSwap public tokenSwap ;

    function setUp() public {
        tokenSwap = new TokenSwap();
    }
    
}