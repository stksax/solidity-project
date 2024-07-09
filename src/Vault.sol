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

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) external {
        uint256 balance = balances[msg.sender];

        require(balance >= _amount, "Insufficient balance");

        //prevent Reentrancy attack
        balances[msg.sender] = balance - _amount;

        payable(msg.sender).transfer(_amount);
    }

    //test
    function depositToken(uint256 _amount) external {
    }

    function withdrawToken(uint256 _amount) external {}

    receive() external payable {}
}

