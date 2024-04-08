/* 

Notes

Objective: deploy a new FundMe contract

1. Our deploy scripts inherit the abstract contract Script from Script.sol
2. This will provide us with two functions startBroadcast() and stopBroadcast() to broadcast contract on chain

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "../lib/forge-std/src/Script.sol";
import {FundMe} from "../src/FundMeV1.sol";

contract DeployFundMe is Script{
    
    function run() external {
        vm.startBroadcast();
        new FundMe();
        vm.stopBroadcast();
    } 
}