// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.24;

contract InvestPlatform {

    struct Investinstruction{
        address stocksOrganization;
        uint deposit;
        uint investbalance;
        uint investgoal;
        uint date;
        address payable[] investorList;
        uint publicPool;
        bool active;
    }

    event Deposit(address indexed from, address indexed to, uint256 amount);
    event InstructionSet(address indexed adviser, address indexed instruction);
    event Invest(address indexed investor, address indexed adviser, uint256 amount);
    event DepositExpire(address indexed adviser);
    event Transfer(address indexed from, address indexed to, uint256 amount);

    mapping(address => Investinstruction) public investinstruction;

    receive() external payable {}

    //to-do: stocksOrganization replace to a orcale
    function adviserSet(address _stocksOrganization, uint _investBalance, uint _investGoal) external payable{
        Investinstruction storage instruction = investinstruction[msg.sender];

        instruction.stocksOrganization = _stocksOrganization;
        instruction.deposit = msg.value;
        instruction.investbalance = _investBalance;
        instruction.investgoal = _investGoal;
        instruction.date = block.timestamp;
        instruction.active = true;

        emit Deposit(msg.sender, address(this), msg.value);
        emit InstructionSet(msg.sender, address(this));
    }


    function invest(address _instruction) external payable {
        Investinstruction storage instruction = investinstruction[_instruction];
        
        require(instruction.active, "This investment project is not active");
        require(msg.value >= instruction.investbalance, "Insufficient balance for investment");

        instruction.investorList.push(payable(msg.sender));
        instruction.publicPool += msg.value;
        instruction.deposit -= instruction.investbalance / 10;

        emit Invest(msg.sender, address(this), msg.value);

        // Check if deposit is sufficient to cover the risk amount
        if (instruction.deposit < instruction.investbalance / 10) {
            instruction.active = false;
            emit DepositExpire(_instruction);
        }
    }

    function calculateReward(address _instruction, uint profit) external {
        Investinstruction storage instruction = investinstruction[_instruction];
        address payable adviser = payable(msg.sender);
        
        require(msg.sender == instruction.stocksOrganization, "Only stocks organization can calculate rewards");
        require(block.timestamp >= instruction.date + 100000, "Cannot calculate reward yet");

        if (profit > instruction.investgoal) {
            for (uint i = 0; i < instruction.investorList.length; i++) {
                instruction.investorList[i].transfer(instruction.investgoal);
                emit Transfer(_instruction, instruction.investorList[i], instruction.investgoal);
                instruction.publicPool -= instruction.investgoal;
            }
            adviser.transfer(instruction.publicPool);
            emit Transfer(_instruction, adviser, instruction.publicPool);
        } else {
            uint insurance = (instruction.publicPool + instruction.deposit) / instruction.investorList.length;
            for (uint i = 0; i < instruction.investorList.length; i++) {
                instruction.investorList[i].transfer(insurance);
                emit Transfer(_instruction, instruction.investorList[i], insurance);
            }
        }
        
        instruction.active = false;
    }

    // function getInvestinstruction(address addr) external view returns (Investinstruction memory) {
    //     return investinstruction[addr];
    // }
}
