// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {

    using PriceConverter for uint256;

    error FundMe__NotOwner();

    AggregatorV3Interface private s_priceFeed;
    address public immutable i_owner;
    uint256 public constant MINIMUM_USD = 5e18;
    address[] public listOfFunders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

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
        listOfFunders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public isOwner {
        for(uint256 _funderIndex=0; _funderIndex < listOfFunders.length; _funderIndex++) {
            address _funder = listOfFunders[_funderIndex];
            addressToAmountFunded[_funder] = 0;
        }
         
         listOfFunders = new address[](0);

         (bool sendSuccess , /* bytes memory dataReturned */) = address(msg.sender).call{ value: address(this).balance }("");
         require(sendSuccess, "Failed to send Ether");
    }

    function getVersion() public view returns(uint256) {
        return s_priceFeed.version();
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}