/* 

Notes

Objective: Write a test to see if MINIMUM_USD is indeed $5 in FundMe.sol

1. Use the Test (abstract contract), console (library)
    - All Test scripts in foundry should inherit the abstract contract Test
    - Use library console to easily print out statements when doing `forge test`
2. assertEq function will be inherited by your test contract
    - Use it to test whether a value is expected
3. Deploy a new contract in a function called setUp()
4. Create a function testMinimumDollarIsFive() to check MINIMUM_USD is $5
5. Create a function testOwnerIsMsgSender() to test msg sender is the owner of the contract
    - We should be checking to see if FundMeTest is the owner instead of whether the msg.sender is the owner
    - us -> FundMeTest -> FundMe
6. Create a function testPriceFeedVersionIsAccurate() to test if the version of the pricefeed is accurate
    - initially the test will revert because we did not pass in a RPC_URL and the contract does not exist in any chain
    - passing a --fork-url flag will allows us to simulate the contract on an actual network depedending on the url
7. forge coverage --fork-url {url} 
    - tells us how much of our code is tested
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMeV1.sol";

contract FundMeTest is Test {

    FundMe _fundMe;

    function setUp() external {
        _fundMe = new FundMe();
    }

    function testMinimumDollarIsFive() public view {
        // console.log(_fundMe.MINIMUM_USD());
        assertEq(_fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(_fundMe.i_owner(), address(this));
    }

    function testPriceFeedVersionIsAccurate() public view {
        assertEq(_fundMe.getVersion(), 4);
    }
}

