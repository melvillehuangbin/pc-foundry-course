/* 
Notes
1. create a contract InteractionsTest that tests the contract FundMe by using the Interactions.s.sol script
2. create setUp() function to get instance of fundMe contract
    - set up its starting balances
3. pass the address of the instance of fundMe contract to contracts in Interactions.s.sol solidity script 
4. create a function testUserCanFundInteractions()
    - to test for fundFundMe and withdrawFundMe functions in Interactions.s.sol
    - test whether fundMe contract has 0 balance after withdrawal


*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMeV2.sol";
import {DeployFundMe} from "../../script/DeployFundMeV2.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/InteractionsV2.s.sol";

contract  InteractionsTest is Test {

    FundMe _fundMe;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant SEND_VALUE = 1 ether;
    address USER = makeAddr("user");

    function setUp() external {
        DeployFundMe _deployFundMe = new DeployFundMe();
        _fundMe = _deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundFundMe _fundFundMe = new FundFundMe();
        _fundFundMe.fundFundMe(address(_fundMe));

        WithdrawFundMe _withdrawFundMe = new WithdrawFundMe();
        _withdrawFundMe.withdrawFundMe(address(_fundMe));

        assert(address(_fundMe).balance == 0);
    }
}