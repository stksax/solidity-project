// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/ERC20.sol";

contract Erc20Test is Test {
    Erc20 public erc20;

    function setUp() public {
        erc20 = new Erc20();
    }

    receive() external payable {}

    function testDeposit() public {
        vm.startBroadcast(address(msg.sender));
        uint balanceBefore = erc20.balanceOf(address(msg.sender));
        erc20.deposit{value:100}();
        uint balanceAfter = erc20.balanceOf(address(msg.sender));
        vm.stopBroadcast();
        assertEq(balanceAfter - balanceBefore, 100);
    }

    function testwithdraw() public {
        vm.startBroadcast(address(msg.sender));
        erc20.deposit{value:150}();
        erc20.withdraw(100);
        uint balance = erc20.balanceOf(address(msg.sender));
        vm.stopBroadcast();
        assertEq(balance, 50);
    }

    function testTransfer() public {
        address reciver = address(123);
        vm.startBroadcast(address(msg.sender));
        erc20.deposit{value:150}();
        erc20.transfer(reciver, 100);
        uint reciverBalance = erc20.balanceOf(reciver);
        uint senderBalance = erc20.balanceOf(address(msg.sender));
        vm.stopBroadcast();
        assertEq(senderBalance, 50);
        assertEq(reciverBalance, 100);
    }

    function testTransferWithApprove() public {
        address agent = address(456);
        address reciver = address(123);

        vm.startBroadcast(address(msg.sender));
        erc20.deposit{value:150}();
        erc20.approve(agent, 150);
        vm.stopBroadcast();

        vm.startBroadcast(agent);
        erc20.transferFrom(msg.sender, reciver, 150);
        uint reciverBalance = erc20.balanceOf(reciver);
        uint senderBalance = erc20.balanceOf(address(msg.sender));
        vm.stopBroadcast();

        assertEq(senderBalance, 0);
        assertEq(reciverBalance, 150);
    }
}
