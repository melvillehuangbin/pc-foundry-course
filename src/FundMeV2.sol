/* 
Notes:

Objective: Refactor code such that the contract will use the address we want to pass in for the pricefeed

Block 1
1. pass an address priceFeed as an argument in the constructor()
2. Initialize a new AggregatorV3Interface object s_priceFeed that will be the pricefeed of the address pass in by the user

Block 2
1. set the storage variables to use the format s_x
2. we also want to keep the visibility of these variables to private unless its necessary to make them public
3. setting them to private means we need to create getters and senders for them

Block 3 - Gas Optimization
1. create a new function cheaperWithdraw() to compare gas cost between old and new withdraw functions
    - read s_funders from within function (memory) rather than from storage
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverterV2.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    using PriceConverter for uint256;

    error FundMe__NotOwner();

    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 5e18;

    AggregatorV3Interface private s_priceFeed;
    address[] private s_listOfFunders;
    mapping(address funder => uint256 amountFunded) public s_addressToAmountFunded;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    modifier isOwner {
        if(msg.sender != i_owner) { revert FundMe__NotOwner(); }
        _;
    }
    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD);
        s_listOfFunders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public isOwner {
        for(uint256 _funderIndex=0; _funderIndex < s_listOfFunders.length; _funderIndex++) {
            address _funder = s_listOfFunders[_funderIndex];
            s_addressToAmountFunded[_funder] = 0;
        }
         
         s_listOfFunders = new address[](0);

         (bool sendSuccess , /* bytes memory dataReturned */) = address(msg.sender).call{ value: address(this).balance }("");
         require(sendSuccess, "Failed to send Ether");
    }

    function cheaperWithdraw() public isOwner {
        uint256 numberOfFunders = s_listOfFunders.length;
        for(uint256 _funderIndex=0; _funderIndex < numberOfFunders; _funderIndex++) {
            address _funder = s_listOfFunders[_funderIndex];
            s_addressToAmountFunded[_funder] = 0;
        }
         
         s_listOfFunders = new address[](0);

         (bool sendSuccess , /* bytes memory dataReturned */) = address(msg.sender).call{ value: address(this).balance }("");
         require(sendSuccess, "Failed to send Ether");
    }

    function getVersion() external view returns(uint256) {
        return s_priceFeed.version();
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function getFunder(
        uint256 _index
    ) external view returns(address) {
        return s_listOfFunders[_index];
    }

    function getAddressToAmountFunded(
        address _fundingAddress
    ) external view returns(uint256) {
        return s_addressToAmountFunded[_fundingAddress];
    }

    function getOwnerAddress() public view returns(address) {
        return i_owner;
    }
}