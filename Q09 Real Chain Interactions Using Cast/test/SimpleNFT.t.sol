// writing test for mint and ownerOF only 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {SimpleNFT} from "../src/SimpleNFT.sol";

contract SimpleNFTTest is Test {
    SimpleNFT public nft;

    address public alice = address(1);

    function setUp() public {
        nft = new SimpleNFT();
    }

    function testMint() public {
        vm.prank(alice);
        nft.mint(1, "ipfs://metadata/1");

        assertEq(nft.ownerOf(1), alice);
        assertEq(nft.tokenURI(1), "ipfs://metadata/1");
    }

    function testCannotMintSameTokenId() public {
        vm.prank(alice);
        nft.mint(1, "ipfs://metadata/1");

        vm.prank(alice);
        vm.expectRevert("NFT already exists");
        nft.mint(1, "ipfs://metadata/another");
    }

    function testMultipleNFTs() public {
        vm.startPrank(alice);
        nft.mint(1, "ipfs://metadata/1");
        nft.mint(2, "ipfs://metadata/2");
        vm.stopPrank();

        assertEq(nft.ownerOf(1), alice);
        assertEq(nft.tokenURI(1), "ipfs://metadata/1");
        assertEq(nft.ownerOf(2), alice);
        assertEq(nft.tokenURI(2), "ipfs://metadata/2");
    }
}