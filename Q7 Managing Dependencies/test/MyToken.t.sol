// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken public myToken;

    address public user;

    function setUp() public {
        myToken = new MyToken();
        user = makeAddr("user");
    }

    function testName() public view{
        assertEq(myToken.name(), "My Token");
    }

    function testSymbol() public view {
        assertEq(myToken.symbol(), "MTK");
    }

    function testInitialSupply() public view {
        assertEq(myToken.totalSupply(), 0);
    }

    function testMint() public {
        uint256 amount = 100 ether;

        myToken.mint(user, amount);

        assertEq(myToken.balanceOf(user), amount);
        assertEq(myToken.totalSupply(), amount);
    }
}