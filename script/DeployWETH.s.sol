// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";


contract WETHTest is Test {
    // WETH 合約地址
    address private constant WETH_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    IERC20 private weth;

    function setUp() public {
        weth = IERC20(WETH_ADDRESS);
    }

    function testDeposit() public {
        uint256 depositAmount = 1 ether;

        // Send Ether to this contract
        vm.deal(address(this), depositAmount);

        // Deposit Ether to WETH
        weth.deposit{value: depositAmount}();
        
        // Check WETH balance
        assertEq(weth.balanceOf(address(this)), depositAmount);

        // Ensure this contract's Ether balance is now 0
        assertEq(address(this).balance, 0);
    }

    function testWithdraw() public {
        uint256 depositAmount = 1 ether;

        // Send Ether to this contract
        vm.deal(address(this), depositAmount);

        // Deposit Ether to WETH
        weth.deposit{value: depositAmount}();
        
        // Withdraw WETH
        weth.withdraw(depositAmount);

        // Check WETH balance
        assertEq(weth.balanceOf(address(this)), 0);

        // Check ether balance
        assertEq(address(this).balance, depositAmount);
    }

    function run() external{
        testDeposit();
    }

    receive() external payable {}
}
interface IERC20 {
    function deposit() external payable;
    function withdraw(uint256 wad) external;
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}