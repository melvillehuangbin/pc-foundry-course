# Lesson 7 Recap

## FundMe.sol Contract
1. **Create a constructor**: Implement a constructor that sets the contract deployer as the owner and initializes a price feed interface.

2. **Implement an `isOwner` modifier**: Write a modifier that ensures only the owner can call certain functions.

3. **Implement the `fund` function**: Write a function that allows users to send Ether to the contract, ensuring the sent amount is above a minimum USD value using a price conversion rate from the price feed.

4. **Implement the `withdraw` function**: Write a function that allows the owner to withdraw all funds from the contract, resetting the list of funders and their funding amounts to zero.

5. **Implement the `cheaperWithdraw` function**: Write a more efficient version of the `withdraw` function that avoids re-iterating over the list of funders.

6. **Implement the `getVersion` function**: Write a function that returns the version of the price feed contract.

7. **Implement fallback and receive functions**: Write functions that automatically call the `fund` function when the contract receives Ether without a function call.

8. **Implement the `getFunder` function**: Write a function that returns the address of a funder at a given index.

9. **Implement the `getAddressToAmountFunded` function**: Write a function that returns the amount funded by a specific address.

10. **Implement the `getOwnerAddress` function**: Write a function that returns the address of the contract owner.

## PriceConverter.sol Contract

Given the following Solidity code snippet, implement the `PriceConverter` library with two functions: `getPrice` and `getConversionRate`.

1. **Implement the `getPrice` function**: This function should take an `AggregatorV3Interface` price feed as an argument and return the latest price as a `uint256`. Use the `latestRoundData` function from the price feed to retrieve the latest price and multiply it by `1e10` to adjust for decimal places.

2. **Implement the `getConversionRate` function**: This function should take a `uint256` representing the current Ether price and an `AggregatorV3Interface` price feed as arguments. It should return the conversion rate as a `uint256`. Use the `getPrice` function to get the latest price from the price feed, multiply it by the current Ether price, and divide the result by `1e18` to adjust for decimal places.

**Hints**:
- Remember to use the `internal` visibility for both functions since they are meant to be used within the library.
- The `latestRoundData` function returns five values, but you only need the second one, which is the latest price.
- The multiplication and division by `1e10` and `1e18` are used to adjust the price for decimal places.

## FundMeTest.t.sol Contract

Given the following Solidity code snippet, implement the `FundMeTest` contract with various functions to test the `FundMe` contract.

1. **Implement the `setUp` function**: This function should deploy a new instance of the `FundMe` contract and assign it to the `_fundMe` variable. It should also deal `STARTING_BALANCE` Ether to the `USER` address.

2. **Implement the `testMinimumDollarIsFive` function**: Write a test to ensure that the `MINIMUM_USD` constant in the `FundMe` contract is equal to `5e18`.

3. **Implement the `testOwnerIsMsgSender` function**: Write a test to ensure that the owner of the `FundMe` contract is the same as the `msg.sender` when the contract is deployed.

4. **Implement the `testPriceFeedVersionIsAccurate` function**: Write a test to ensure that the version of the price feed contract is `4`.

5. **Implement the `testFundFailsWithoutEnoughETH` function**: Write a test to ensure that the `fund` function in the `FundMe` contract reverts when called with a value of `0 ether`.

6. **Implement the `testFundUpdatesFundedDataStructure` function**: Write a test to ensure that the `fund` function correctly updates the amount funded by the `USER` address.

7. **Implement the `testAddsFunderToArrayOfFunders` function**: Write a test to ensure that the `fund` function correctly adds the `USER` address to the array of funders.

8. **Implement the `testOnlyOwnerCanWithdraw` function**: Write a test to ensure that the `withdraw` function in the `FundMe` contract reverts when called by someone other than the owner.

9. **Implement the `testWithDrawWithASingleFunder` function**: Write a test to ensure that the `withdraw` function correctly transfers all funds from the `FundMe` contract to the owner's account when there is only one funder.

10. **Implement the `testWithdrawFromMultipleFunders` and `testWithdrawFromMultipleFundersCheaper` functions**: Write tests to ensure that the `withdraw` and `cheaperWithdraw` functions correctly transfer all funds from the `FundMe` contract to the owner's account when there are multiple funders.

**Hints**:
- Use the `vm.prank` function to simulate transactions from different addresses.
- Use the `vm.deal` function to assign Ether to an address.
- Use the `assertEq` function to check for equality in your tests.
- Remember to use the `funded` modifier to ensure that the `USER` address has funded the contract before running certain tests.

## DeployFundMe.s.sol Contract

Given the following Solidity code snippet, implement the `DeployFundMe` contract with a `run` function to deploy a new instance of the `FundMe` contract.

1. **Implement the `run` function**: This function should deploy a new instance of the `FundMe` contract using the address of the ETH/USD price feed obtained from the `HelperConfig` contract. It should return the newly deployed `FundMe` contract instance.

**Hints**:
- Use the `vm.startBroadcast` and `vm.stopBroadcast` functions to control the broadcasting of transactions.
- The `HelperConfig` contract is used to obtain the address of the ETH/USD price feed.
- The `FundMe` contract constructor requires the address of the price feed as an argument.


## HelperConfig.s.sol

Given the following Solidity code snippet, implement the `HelperConfig` contract with a constructor and functions to configure the active network configuration based on the current blockchain ID.

1. **Implement the `constructor` function**: This function should set the `activeNetworkConfig` based on the current blockchain ID. If the blockchain ID is `11155111`, it should use the Sepolia ETH configuration. If the blockchain ID is `1`, it should use the Mainnet ETH configuration. For any other blockchain ID, it should use or create an Anvil ETH configuration.

2. **Implement the `getSepoliaEthConfig` function**: Write a function that returns a `NetworkConfig` struct with the Sepolia ETH price feed address.

3. **Implement the `getMainnetEthConfig` function**: Write a function that returns a `NetworkConfig` struct with the Mainnet ETH price feed address.

4. **Implement the `getOrCreateAnvilEthConfig` function**: Write a function that returns a `NetworkConfig` struct with the Anvil ETH price feed address. If the `activeNetworkConfig.priceFeed` is not set, it should deploy a new `MockV3Aggregator` contract and use its address as the price feed.

**Hints**:
- Use the `block.chainid` to determine the current blockchain ID.
- The `NetworkConfig` struct should contain an `address` field for the price feed.
- Use the `vm.startBroadcast` and `vm.stopBroadcast` functions to control the broadcasting of transactions when deploying the `MockV3Aggregator` contract.

## Interactions.s.sol

Given the following Solidity code snippet, implement the `FundFundMe` and `WithdrawFundMe` contracts with functions to fund and withdraw from a `FundMe` contract instance.

1. **Implement the `fundFundMe` function**: This function should take the address of the most recently deployed `FundMe` contract as an argument. It should then call the `fund` function on the `FundMe` contract instance, sending a predefined `SEND_VALUE` amount of Ether.

2. **Implement the `run` function in `FundFundMe`**: Write a function that retrieves the address of the most recently deployed `FundMe` contract using the `DevOpsTools.get_most_recent_deployment` function and then calls the `fundFundMe` function with this address.

3. **Implement the `withdrawFundMe` function**: Similar to `fundFundMe`, this function should take the address of the most recently deployed `FundMe` contract as an argument. It should then call the `withdraw` function on the `FundMe` contract instance.

4. **Implement the `run` function in `WithdrawFundMe`**: Write a function that retrieves the address of the most recently deployed `FundMe` contract using the `DevOpsTools.get_most_recent_deployment` function and then calls the `withdrawFundMe` function with this address.

**Hints**:
- Use the `vm.startBroadcast` and `vm.stopBroadcast` functions to control the broadcasting of transactions.
- The `DevOpsTools.get_most_recent_deployment` function is used to retrieve the address of the most recently deployed `FundMe` contract.
- Ensure that the `FundMe` contract instance is correctly cast to `payable` when calling its functions.

## InteractionsTest.t.sol

Given the following Solidity code snippet, implement the `InteractionsTest` contract with a `setUp` function and a `testUserCanFundInteractions` function to test the interactions with a `FundMe` contract.

1. **Implement the `setUp` function**: This function should deploy a new instance of the `FundMe` contract using the `DeployFundMe` contract and assign it to the `_fundMe` variable. It should also deal `STARTING_BALANCE` Ether to the `USER` address.

2. **Implement the `testUserCanFundInteractions` function**: Write a test to ensure that a user can fund and then withdraw from the `FundMe` contract. This function should create instances of `FundFundMe` and `WithdrawFundMe` contracts, use them to fund and then withdraw from the `FundMe` contract, and finally assert that the balance of the `FundMe` contract is zero.

**Hints**:
- Use the `vm.deal` function to assign Ether to an address.
- Use the `DeployFundMe.run` function to deploy a new `FundMe` contract instance.
- Ensure that the `FundFundMe` and `WithdrawFundMe` contracts are correctly interacting with the `FundMe` contract by funding and withdrawing Ether.
- Use the `assert` function to check that the final balance of the `FundMe` contract is zero after funding and withdrawing.

