
 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {Vault} from "../src/Vault.sol";

contract VaultScript is Script {
    Vault public vault;

    function run() external {
        vm.startBroadcast();

        vault = new Vault();

        vm.stopBroadcast();
    }
}
