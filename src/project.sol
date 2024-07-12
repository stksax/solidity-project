// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract InvestPlatform {

    struct InvestorInformation{
        address payable name;
        uint investment;
    }

    struct Investinstruction{
        address payable adviser;
        address stocksOrganization;
        uint deposit;
        uint investbalance;
        uint investgoal;
        uint date;
        InvestorInformation[] investorList;
        bool active; 
    }

    event  Deposit(address name, address toaddr, uint balance);
    event  InstructionSet(address adviser, address instruction);
    event  Invest(address invsetor, address adviser, uint balance);
    event  DepositExpire(address adviser);
    event  Transfer(address from, address to, uint balance); 
    
    
    mapping (address => Investinstruction) public investinstruction;

    receive() external payable { }

    //to-do: stocksOrganization replace to a orcale 
    function adviserSet(address _stocksOrganization, uint _investBalance, uint _investGoal) external payable{
        Investinstruction memory instruction;
        instruction.adviser = payable(msg.sender);
        instruction.stocksOrganization = _stocksOrganization;
        instruction.deposit = msg.value;
        instruction.investbalance = _investBalance;
        instruction.investgoal = _investGoal;
        instruction.date = block.timestamp;
        instruction.active = true;
        investinstruction[msg.sender] = instruction;
        emit Deposit(msg.sender, address(this), msg.value);
        emit InstructionSet(msg.sender, address(this));
    }


    function invest(address _instruction) external payable{
        Investinstruction storage instruction = investinstruction[_instruction];
        require(instruction.active == true, "this invest project not active yet");
        //require(instruction.deposit >= (investbalance/10), "deposit not enough for 10% of invest, for ensure invest risk");
        require(msg.value >= instruction.investbalance, "balance not enough for investment");

        InvestorInformation memory investorInformation;
        investorInformation.name = payable(msg.sender);
        investorInformation.investment = msg.value;

        instruction.investorList.push(investorInformation);
        instruction.deposit -= instruction.investbalance/10;
        emit Invest( msg.sender, address(this),msg.value);
        //check deposit is affordable
        if (instruction.deposit < instruction.investbalance/10){
            instruction.active = false;
            emit DepositExpire(_instruction);
        }
    }

    function check(address _instruction, uint profit) external payable{
        Investinstruction storage instruction = investinstruction[_instruction];
        require(msg.sender == instruction.stocksOrganization);
        require(block.timestamp >= instruction.date + 100000);
        uint adviserReward = 0;
        if (profit > instruction.investgoal){
            for (uint i = 0; i < instruction.investorList.length; i++) {
                instruction.investorList[i].name.transfer(instruction.investgoal);
                emit Transfer(_instruction, instruction.investorList[i].name, instruction.investgoal);
                adviserReward += instruction.investorList[i].investment - instruction.investgoal;
            }
            instruction.adviser.transfer(adviserReward);
            emit Transfer(_instruction, instruction.adviser, adviserReward);
        }else{
            for (uint i = 0; i < instruction.investorList.length; i++) {
                instruction.investorList[i].name.transfer(instruction.investbalance/10);
                emit Transfer(_instruction, instruction.investorList[i].name, instruction.investbalance/10);
            }
        }
        instruction.active = false;
    }
}