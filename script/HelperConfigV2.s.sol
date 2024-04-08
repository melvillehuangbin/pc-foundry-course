// 1. Deploy mocks when we are on a local anvil chain
// 2. Keep track of contract address across different chains
// Sepolia ETH/USD
// Mainnet ETH/USD

/* 
Notes:

Objective: create a HelperConfig contract that can select the pricefeed base on chain we are on detected when we pass in the rpc url in the --fork-url flag

1. create a function getSepoliaEthConfig() to get the mock price feed on Sepolia chain
    - do this by creating a NetworkConfig object (remember the memory keyword)
2. create a function getMainnetEthConfig() to get the mock price feed on Main net chain
3. create a constructor that checks for the block.chainid global variable
    - depending on which chainid we are on, set the activeNetworkConfig variable to the relevant configs
4. create a public variable activeNetworkConfig to be accessible by DeployFundMeV2 contract
5. create a function getAnvilEthConfig() that returns a NetworkConfig object 
    - cannot be pure function -> using the vm keyword from Script 
    - copy and paste the new MockV3Aggregator.sol contract on PC github repo and place it in a mocks folder within test folder
    - create a new Mockv3Aggregator object
6. Magic Numbers - random numbers in code that mean something
    - turn them into constants at the start of code
7. Add a check to see if activeNetworkConfig.priceFeed has been set to 0 (address defaults to 0)
    - if no then return the activeNetworkConfig (since contract has already been deployed)
    - if yes then deploy a new MockV3Aggregator contract
8. rename function getAnvilEthConig() -> getOrCreateAnvilEthConfig() to improve readability
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "../lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {

    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_ANSWER = 2000e8;

    struct NetworkConfig {
        address priceFeed; 
    }

    constructor() {
        if(block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainnetConfig;
    }

    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory) {
        // price feed address
        
        // 1. deploy the mocks
        // 2. Return the mock address

        if(activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_ANSWER
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}