// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {

    using PriceConverter for uint256;

    address private immutable i_owner;
    uint256 public constant MINIMUM_USD = 5e18;
    address[] private listOfFunders;
    mapping(address funder => uint256 amountFunded) private addressToAmountFunded;
    error FundMe__NotOwner();
    AggregatorV3Interface private s_priceFeed;

    constructor(
        address priceFeed
    ) {
        i_owner = msg.sender;
        // initialize a priceFeed interface
         s_priceFeed = AggregatorV3Interface(priceFeed);
    }


    modifier isOwner() {
        if(msg.sender != i_owner) { revert FundMe__NotOwner(); }
        _;
    }

    function fund() public payable {
        // allows users to send Ether to the contract, ensuring amount sent is above minimum USD
        // we want to also add the funder into a list of funders
        // also record the total amount funded by each funder 
        require(msg.value.getConversionRate(s_priceFeed) > MINIMUM_USD); //msg.value is in ether (need to convert)
        listOfFunders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public isOwner {
        uint256 numberOfFunders = listOfFunders.length;
        // set each funder's funding amount to zero
        for(uint256 funderIndex = 0; funderIndex < numberOfFunders; funderIndex++) {
            address funder = listOfFunders[funderIndex];
            addressToAmountFunded[funder] =0;
        }

        // reset list of funders
        listOfFunders = new address[](0);

        // withdraw amount in contract and send to owner
        (bool transactionSuccess,) = address(msg.sender).call{value: address(this).balance}("");
        require(transactionSuccess, "Failed to send ether");
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
        uint256 funderIndex
    ) external view returns(address) {
        return listOfFunders[funderIndex];
    }

    function getAddressToAmountFunded(
        address funder
    ) external view returns(uint256) {
        return addressToAmountFunded[funder];
    }

    function getOwnerAddress() external view returns(address) {
        return i_owner;
    }

}