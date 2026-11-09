// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {Greeting} from "../src/Greeting.sol";

contract GreetingTest is Test {
    Greeting public greeting;

    function setUp() public {
        greeting = new Greeting();
    }

    function testFuzz_setGreeting(string memory _greet) public{
        greeting.setGreeting(_greet);
        assertEq(greeting.greet() , _greet);
    }
}