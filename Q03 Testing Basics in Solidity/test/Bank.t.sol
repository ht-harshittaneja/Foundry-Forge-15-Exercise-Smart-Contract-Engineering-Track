// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {Bank} from "../src/Bank.sol";

contract BankTest is Test {
    Bank public bank;

    function setUp() public {
        bank = new Bank();
    }

    function test_GetBalanceInitiallyZero() public view {
        assertEq(bank.getBalance(), 0);
    }

    function test_RevertWhenZeroDeposit() public{
        vm.expectRevert("Deposit must be greater than zero");
        bank.deposit{value: 0}(); // bank.deposit(); will also work
    }

    function test_Deposit() public {
        vm.deal(address(this), 10 ether);
        bank.deposit{value: 1 ether}();
        assertEq(bank.getBalance() ,1 ether);
    }

    function test_MultipleDeposits() public {
        vm.deal(address(this), 10 ether);
        bank.deposit{value: 1 ether}();
        bank.deposit{value: 2 ether}();
        assertEq(bank.getBalance(), 3 ether);
    }

    function test_RevertWhenZeroWithdraw() public{
        vm.expectRevert("Amount must be greater than zero");
        bank.withdraw(0); 
    }

    function test_RevertWhenInsufficentFundWithdraw() public{
        vm.expectRevert("Insuficient Balance");
        bank.withdraw(10); //initally zero balance
    }

    function test_Withdraw() public {
        vm.deal(address(this), 10 ether);
        bank.deposit{value: 1 ether}();
        bank.withdraw(0.4 ether);
        assertEq(bank.getBalance(), 0.6 ether);
    }

    receive() external payable {}
    
}