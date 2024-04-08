/* 

Notes:

Objective: Refactor code such that the contract will use the address we want to pass in for the pricefeed

1. pass in an address priceFeed into the run() function
2. return the fundme contract that is newly deployed in the run() function
3. Create a Mock contract - we can create a mock pricefeed in the duration of our test and interact with it
    - Create a HelperConfig.s.sol script file
    - call the activeNetworkConfig variable (since this is a struct, usually we have to add the parenthesis when assigning struct values variables)
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "../lib/forge-std/src/Script.sol";
import {FundMe} from "../src/FundMeV2.sol";
import {HelperConfig} from "../script/HelperConfigV2.s.sol";

contract DeployFundMe is Script{
    
    function run() external returns (FundMe) {
        // not broadcasted as txn
        HelperConfig _helperConfig = new HelperConfig();
        (address ethUsdPriceFeed) = _helperConfig.activeNetworkConfig();

        // broadcasted as txn
        vm.startBroadcast();
        // Mock
        FundMe _fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return _fundMe;
    } 
}