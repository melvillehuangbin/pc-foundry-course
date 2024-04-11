/* 

Notes:

Objective: Refactor code such that the contract will use the address we want to pass in for the pricefeed

Block 1
1. import DeployFundMe() contract
2. deploy a new contract in the setUp() function of the Test contract
    - do this by initializing a new DeployFundMe contract running the run() function
3. change the test for whether msg sender is the owner back to msg.sender
    - delegatecall?

Block 2
1. write a new function testFundFailsWithoutEnoughETH that passes whenever we do not send enough funds
    - use the vm.expectRevert() cheatcode
    - essentially this test makes sure that our contract FundMe will revert the transaction if the minimum amount funded is not $5
2. write a new function testFundUpdatesFundedDataStructure()
    - this test aims to test whether amount funded by the user is the same as the value send
    - after setting storage variables to private in FundMe contract, use the relevant getter to get the variable to be tested
    - tip: to pass send value we can do .method{value: xx}();
    - prank() cheat code sets msg.sender as the specified address for the next call
    - we can use prank() to know exactly who is sending the next call
        - the next transaction after prank will be send by the USER pass in the method
    - use cheat code vm.makeAddr() that takes in a string name and gives us back a address
    - make SEND_VALUE, STARTING_BALANCE a constant variable for Magic Number
    - use cheat code vm.deal() our fake user some starting balances in the function setUp()

Block 3
1. write a new function testAddsFunderToArrayOfFunders
    - test for whether the address of the user who send transaction is the same as the funder
    - Note: every single type one of the tests is ran, it will run the setUp() function and start the test function and restart again.

2. write a new function testOnlyOwnerCanWithdraw()
    - test for whether only the owner can with draw funds
3. Solidity best practices
    - Use a modifier for repeated code logic within test scripts
        - In this case its to set the address of the USER sending the transaction and attempt to send funds
        - create a modifier funded()
4. Arrange, Act, Assert methodology for test -> compartmentalize the different parts of the test
5. write a function testWithDrawWithASingleFunder()
    - convert owner address variable from FundMe contract to private variable and create a getter for the contract
    - check that our starting balance of the FundMe contract and the Owner is the same as the ending balance of the Owner account
6. write a function testWithdrawFromMultipleFunders() 
    - test for whether starting balance of fund me contract from multiple funders + starting balance of owner = ending balance of owner after withdrawing
    - use hoax - vm.prank + vm.deal combine
    - if we want to use numbers to generate addresses, the number must be uint160 from solidty v0.8.0 onwards
    - good practice to not use 0 to generate address for tests
7. chisel
    - CLI tool to run quick solidity code

Block 4 - Making our tests more gas efficient
1. forge snapshot {Test}
    - tells us how much this single test cost
2. when we use Anvil (local) chain to test our contracts, gas price defaults to 0
    - To simulate actual gas prices, we can use cheat code txGasPrice in FundMe contract
    - gasleft() - tells us how much gas is left in the transaction call
    - gasprice() - tells us how much is the current gasprice
3. forge inspect {Contract} storageLayout
    - provides us with the storage layout of the contract
4. cast storage {contractAdrress}
    - see a contracts storage
    - deploy on local anvil chain
    - do on a live contract
    - we should be reading and writing from memory a lot more than we are reading and writing from storage
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMeV2.sol";
import {DeployFundMe} from "../../script/DeployFundMeV2.s.sol";

contract FundMeTest is Test {

    FundMe _fundMe;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant SEND_VALUE = 1 ether;
    address USER = makeAddr("user");

    modifier funded() {
        vm.prank(USER);
        _fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function setUp() external {
        DeployFundMe _deployFundMe = new DeployFundMe();
        _fundMe = _deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        // console.log(_fundMe.MINIMUM_USD());
        assertEq(_fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(_fundMe.getOwnerAddress(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        assertEq(_fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        _fundMe.fund{value: 0 ether} (); // send 0 value
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        _fundMe.fund{value: SEND_VALUE}();

        uint256 _amountFunded = _fundMe.getAddressToAmountFunded(USER);
        assertEq(_amountFunded, SEND_VALUE);
    }


    function testAddsFunderToArrayOfFunders() public funded {
        address _funder = _fundMe.getFunder(0);
        assertEq(_funder, USER);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        _fundMe.withdraw();
    }

    function testWithDrawWithASingleFunder() public funded {
        //check that our starting balance of the FundMe contract and the Owner is the same as the ending balance of the Owner account
        
        // Arrange 
        uint256 _startingFundMeBalance = address(_fundMe).balance;
        uint256 _startingOwnerBalance = _fundMe.getOwnerAddress().balance;

        // Act
        vm.prank(_fundMe.getOwnerAddress());
        _fundMe.withdraw();

        // Assert
        uint256 _endingFundMeBalance = address(_fundMe).balance;
        uint256 _endingOwnerBalance = _fundMe.getOwnerAddress().balance;
        assertEq(_endingFundMeBalance, 0);
        assertEq(
            _startingFundMeBalance + _startingOwnerBalance,
            _endingOwnerBalance
        );
    }

    function testWithdrawFromMultipleFunders() public {
        // Arrange
        uint160 _numberOfFunders = 10;
        uint160 _startingIndex = 1;
        for(uint160 i=_startingIndex; i < _numberOfFunders; i++) {
            // vm.prank()
            // vm.deal()
            // address()
            hoax(address(i), SEND_VALUE);
            _fundMe.fund{value: SEND_VALUE}();
        }   


        uint256 _startingFundMeBalance = address(_fundMe).balance;
        uint256 _startingOwnerBalance = _fundMe.getOwnerAddress().balance;

        // Act
        vm.startPrank(_fundMe.getOwnerAddress());
        _fundMe.withdraw();
        vm.stopPrank();

        // Assert
        uint256 _endingFundMeBalance = address(_fundMe).balance;
        uint256 _endingOwnerBalance = _fundMe.getOwnerAddress().balance;
        assert(_endingFundMeBalance == 0);
        assertEq(
            _startingFundMeBalance + _startingOwnerBalance, 
            _endingOwnerBalance
        );
    }

    function testWithdrawFromMultipleFundersCheaper() public {
        // Arrange
        uint160 _numberOfFunders = 10;
        uint160 _startingIndex = 1;
        for(uint160 i=_startingIndex; i < _numberOfFunders; i++) {
            // vm.prank()
            // vm.deal()
            // address()
            hoax(address(i), SEND_VALUE);
            _fundMe.fund{value: SEND_VALUE}();
        }   


        uint256 _startingFundMeBalance = address(_fundMe).balance;
        uint256 _startingOwnerBalance = _fundMe.getOwnerAddress().balance;

        // Act
        vm.startPrank(_fundMe.getOwnerAddress());
        _fundMe.cheaperWithdraw();
        vm.stopPrank();

        // Assert
        uint256 _endingFundMeBalance = address(_fundMe).balance;
        uint256 _endingOwnerBalance = _fundMe.getOwnerAddress().balance;
        assert(_endingFundMeBalance == 0);
        assertEq(
            _startingFundMeBalance + _startingOwnerBalance, 
            _endingOwnerBalance
        );
    }
}

