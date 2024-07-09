// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Vault, DemoToken} from "../src/Vault.sol";

contract VaultTest is Test {
    Vault public vault;
    DemoToken public token;

    function setUp() public {
        vault = new Vault();
        token = new DemoToken();
        token.mint(address(this), 1000);
        token.approve(address(vault), 1000);
    }

    function test_DepositEth() public {
        vault.deposit{value: 100}();
        assertEq(vault.balances(address(this)), 100);
    }

    function test_WithdrawEth() public {
        vault.deposit{value: 100}();
        vault.withdraw(100);
        assertEq(vault.balances(address(this)), 0);
    }

    function test_DepositToken() public {
        vault.depositToken(100);
    }

    function test_WithdrawToken() public {
        vault.withdrawToken(100);
    }

    receive() external payable {}
}
