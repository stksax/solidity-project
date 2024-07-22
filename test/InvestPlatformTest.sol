// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/InvestPlatform.sol"; 

contract InvestPlatformTest is Test {

    InvestPlatform public platform;

    constructor() {
        platform = new InvestPlatform();
    }

    receive() external payable {}

    function testInvestSuccess() public {
        address payable stocksOrganization = payable(address(1111));
        //adviser start a new invest project
        platform.adviserSet{value: 2000}(stocksOrganization, 200, 250);

        InvestPlatform.Investinstruction memory structData = platform.getInvestinstruction(address(this));
        uint deposit = structData.deposit;
        assertEq(deposit, 2000);

        //user send money to invest pool
        address payable user1 = payable(address(11));
        user1.transfer(200);
        vm.prank(user1);
        platform.invest{value:200}(address(this));
        address payable user2 = payable(address(12));
        user2.transfer(200);
        vm.prank(user2);
        platform.invest{value:200}(address(this));
        address payable user3 = payable(address(13));
        user3.transfer(200);
        vm.prank(user3);
        platform.invest{value:200}(address(this));

        uint profit = 300;
        //time pass
        skip(100000);
        //simulate the bountyPool add 300 after a success invest
        platform.changebountyPool{value:300}(true, 0);
        vm.prank(stocksOrganization);
        platform.calculateReward(address(this), profit);

        //test user1's blance by transfer to other
        vm.prank(user1);
        bool ans1 = user3.send(251);
        assertFalse(ans1);
        bool ans2 = user3.send(250);
        assertTrue(ans2);
        //user1's blance is 250(investgoal) 
    }

    function testInvestFail() public {
        address payable stocksOrganization = payable(address(1111));
        //adviser start a new invest project
        platform.adviserSet{value: 300}(stocksOrganization, 200, 250);

        InvestPlatform.Investinstruction memory structData = platform.getInvestinstruction(address(this));
        uint deposit = structData.deposit;
        assertEq(deposit, 300);

        //user send money to invest pool
        address payable user1 = payable(address(11));
        user1.transfer(200);
        vm.prank(user1);
        platform.invest{value:200}(address(this));
        address payable user2 = payable(address(12));
        user2.transfer(200);
        vm.prank(user2);
        platform.invest{value:200}(address(this));
        address payable user3 = payable(address(13));
        user3.transfer(200);
        vm.prank(user3);
        platform.invest{value:200}(address(this));

        //time pass
        skip(100000);
        //simulate the bountyPool add 300 after a success invest
        platform.changebountyPool(false, 300);
        vm.prank(stocksOrganization);
        platform.calculateReward(address(this), 150);

        //test user1's blance by transfer to other
        vm.prank(user1);
        bool ans1 = user3.send(201);
        assertFalse(ans1);
        bool ans2 = user3.send(200);
        assertTrue(ans2);
        //user1's blance is (600-300)/3 (public pool) + 300/3(claims) = 200
    }
}