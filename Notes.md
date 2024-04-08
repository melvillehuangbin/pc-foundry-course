# Lesson 7 to 11 Notes

## Set Up

1. Create FundMe.sol and PriceConverter.sol in the src file
2. forge install {url} --no-commit depedencies directly from github
3. Once downloaded, do a remapping
    - redirect @chainlink/contracts = lib/chainlink-brownie-contracts/contracts/
4. Name your errors using the format {Contract}__{ErrorName}

## Test 

Write the `FundMeTest` contract to test `FundMe` contract

1. Import some build in contracts/libraries from build in contracts i.e `Test`, `console` foundry libraries
2. Write the `setUp()` and `testDemo` functions
    - `setUp()` will always run first
    - create new `FundMe` contract
3. Import the contract to be tested. i.e. `FundMe`
4. After importing contract to be tested, we can pick public variables / functions to be tested
    - use `assertEq` function to test
    - we call variables in using {contract}.{variable}
    - test whether `MINIMUM_USD` is the correct value
5. test whether the test owner is the `msg.sender`
    - you will notice the test fails because the owner of the contract is the testFundMe contract which we call which then deploys FundMe
    - us -> testFundMe -> FundMe
    - test for whether the `FundMeTest` is the owner instead of whether `msg.sender` is the owner
6. Create a new contract called `DeployFundMe.s.sol` in scripts folder

- Note: Libraries and Interfaces need to be imported in the contract

## Types of Tests
1. Unit
- Testing Specific part of code
2. Integration
- Testing how our code works with other parts of code
3. Forked 
- Testing our code in a simulated real environment
4. Staging
- Testing our code in a real environment that is not prod

## Forked Tests

1. write a new test to check whether price feed version is accurate from the chainlink oracle
2. we can do `forge test -m {testName} -vvvv` to run a single test
3. pass in the `--fork-url {url}` parameter and set `url` in the `.env` file
    - it will pretend and test on the Sepolia chain
    - this lets us easily test our contracts on a simulated environment
4. `forge coverage --fork-url {RPC_URL}`: tells us how many lines of our code is covered

## Refactoring our Test Code

Objective: Include other chains other than Sepolia to test our contracts on. No hardcoding on contracts

1. create a `AggregatorV3Interface` interface variable called `s_priceFeed` and pass it as an argument in the `constructor()` function in FundMe.sol 
2. call `.version()` directly on newly created `s_priceFeed` variable
3. import `DeployFundMe` into the `FundMeTest` script and execute the `run()` function to create a new `FundMe` contract during each test run
4. By using `DeployFundMe` contract to call the `FundMe` contract, the msg.sender is now the contract owner (delegate call)