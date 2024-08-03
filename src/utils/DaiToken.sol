// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.24;
import '../interfaces/IERC20.sol';

contract DaiToken is IERC20{
    string public name = "Test Erc20 Coin";
    string public symbol = "TEC";

    event Approval(address indexed msgsender, address indexed guy, uint256 amount);
    event Transfer(address indexed msgsender, address indexed reciver, uint256 amount);
    event Deposit(address indexed msgsender, uint256 amount);
    event Withdrawal(address indexed msgsender, uint256 amount);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    receive() external payable {
        deposit();
    }

    function deposit() public payable{
        balanceOf[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint amount) public payable{
        require(amount <= balanceOf[msg.sender]);
        balanceOf[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }

    function totalSupply() public view returns (uint256) {
        return address(this).balance;
    }

    function approve(address agent, uint256 amount) public returns (bool) {
        allowance[msg.sender][agent] = amount;
        emit Approval(msg.sender, agent, amount);
        return true;
    }

    function transfer(address reciver, uint256 amount) public returns (bool) {
        return transferFrom(msg.sender, reciver, amount);
    }

    function transferFrom(address sender, address reciver, uint256 amount)
        public
        returns (bool)
    {
        if (
            sender != msg.sender && allowance[sender][msg.sender] != type(uint256).max
        ) {
            allowance[sender][msg.sender] -= amount;
        }

        balanceOf[sender] -= amount;
        balanceOf[reciver] += amount;

        emit Transfer(sender, reciver, amount);

        return true;
    }
}
