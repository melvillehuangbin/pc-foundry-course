// Fund
// Withdraw

/* 
Notes

Block 1
1. create a FundFundMe contract and WithdrawFundMe contract
2. forge install Cyfrin/foundry-devops
    - provides us with a tool for foundry to get most recently deployed contract
    - set ffi = true in foundry.toml file
        - WARNING: lets foundry run commands on cli
3. forge script {path to script}:{ContractName} to pick the contract to run

Block 2
1. create FundFundMe contract
    - create two functions run() and fundFundMe()
    - run()
        - run the fundFundMe() function using the most recently deployed FundMe contract
    - fundFundMe() 
        - call the fund() method from FundMe contract
    - create an instance of the latest FundMe contract
    - DevOpsTools.get_most_recent_deployment(contractName, chainId)
        - gives us most recent deployment of contract
    - create a fundFundMe() function to fund the FundMe contract
        - console.log just to see if the value is send
2. run forge script {script/..}:contractName --rpc-url xx --private-key xx --broadcast

Block 3
1. create the WithdrawFundMe contract 
    - create two functions run() and withdrawFundMe

    
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMeV2.sol";

contract FundFundMe is Script {

    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe", 
            block.chainid
        );
        fundFundMe(mostRecentlyDeployed);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        // get address of most recently deployed contract
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe", 
            block.chainid
        );
        withdrawFundMe(mostRecentlyDeployed); 
    }
}
