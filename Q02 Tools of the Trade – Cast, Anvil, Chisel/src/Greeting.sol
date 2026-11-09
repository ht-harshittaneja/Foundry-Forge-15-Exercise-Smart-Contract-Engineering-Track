// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract Greeting {
    string public greet = "HI";

    function setGreeting(string memory _greet) public {
        greet = _greet ;
    }
}