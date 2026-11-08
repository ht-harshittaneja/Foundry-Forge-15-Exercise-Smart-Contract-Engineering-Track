// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {Multisig} from "../src/Multisig.sol";

contract MultisigScript is Script {
    Multisig public wallet;

    function run() external {
        address alice = vm.envAddress("ALICE");
        address bob = vm.envAddress("BOB");
        address charlie = vm.envAddress("CHARLIE");

        vm.startBroadcast();

        wallet = new Multisig(alice, bob, charlie);

        vm.stopBroadcast();
    }
}
