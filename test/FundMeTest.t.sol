// SPDX-License-Identifier: MIt

pragma solidity ^0.8.19;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {

    FundMe _fundMe;

    // this function will always run first 
    // set up a new contract to be tested
    function setUp() external {
        // _fundMe = new FundMe(priceFeed);
        DeployFundMe _deployFundMe = new DeployFundMe();
        _fundMe = _deployFundMe.run();
    }

    // test whether minimum usd is the expected correct value
    function testMinimumUsdIsFive() public view {
        assertEq(_fundMe.MINIMUM_USD(), 5e18);
    }

    // test whether address of contract is address of owner
    // address of owner is initialized as the address of the message sender
    function testIsOwner() public view {
        assertEq(_fundMe.i_owner(), msg.sender);
    }

    // test whether we are using the correct version of price feed as expected
    function testPriceFeedVersion() public view {
        uint256 version = _fundMe.getVersion();
        assertEq(version, 4);
    }
}