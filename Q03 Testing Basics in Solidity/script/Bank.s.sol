// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Script} from "forge-std/Script.sol";
import {Bank} from "../src/Bank.sol";

contract BankScript is Script {
    Bank public bank;

    function run() public {
        vm.startBroadcast();
        bank = new Bank();
        vm.stopBroadcast();
    }
}