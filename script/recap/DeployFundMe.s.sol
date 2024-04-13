// SPDX-License-Identifier: MIT


// comments
pragma solidity ^0.8.19;

import {FundMe} from "../../src/recap/FundMe.sol";
import {Script} from "../../lib/forge-std/src/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {

    function run() external returns(FundMe) { 
    
      // get priceFeed address
      HelperConfig helperConfig = new HelperConfig();
      (address ethUsdPriceFeed) = helperConfig.activeNetworkConfig();

      vm.startBroadcast();
      FundMe fundMe = new FundMe(ethUsdPriceFeed);  
      vm.stopBroadcast();

      return fundMe;
    } 
}