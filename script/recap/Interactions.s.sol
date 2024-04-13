// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {FundMe} from "../../src/FundMeV2.sol";
import {Script, console} from "../../lib/forge-std/src/Script.sol";
import {DevOpsTools} from "../../lib/foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {

    uint256 constant SEND_VALUE = 0.1 ether;

    function fundFundMe(
        address mostRecentlyDeployed
    ) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentFundMe = DevOpsTools.get_most_recent_deployment(
            "FundMe", 
            block.chainid
        );
        fundFundMe(mostRecentFundMe);
    }
}

contract WithdrawFundMe is Script {

    function withdrawFundMe(
        address mostRecentlyDeployed
    ) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentFundMe = DevOpsTools.get_most_recent_deployment(
            "FundMe", 
            block.chainid
        );
        withdrawFundMe(mostRecentFundMe);  
    }
}