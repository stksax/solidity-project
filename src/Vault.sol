// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DemoToken is ERC20 {
    constructor() ERC20("DemoToken", "DT") {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract Vault {
    mapping(address => uint256) public balances;
    mapping(address => uint256) public tokenBalances;
    ERC20 public token;

    constructor(ERC20 _token) {
        token = _token;
    }

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) external {
        uint256 balance = balances[msg.sender];
        require(balance >= _amount, "Insufficient balance");

        // Prevent Reentrancy attack
        balances[msg.sender] = balance - _amount;

        payable(msg.sender).transfer(_amount);
    }

    function depositToken(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");

        // Transfer tokens from the user to the Vault
        require(token.transferFrom(msg.sender, address(this), _amount), "Token transfer failed");

        // Update the user's token balance in the Vault
        tokenBalances[msg.sender] += _amount;
    }

    function withdrawToken(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        uint256 balance = tokenBalances[msg.sender];
        require(balance >= _amount, "Insufficient token balance");

        // Update the user's token balance in the Vault
        tokenBalances[msg.sender] = balance - _amount;

        // Transfer tokens from the Vault to the user
        require(token.transfer(msg.sender, _amount), "Token transfer failed");
    }

    receive() external payable {}
}