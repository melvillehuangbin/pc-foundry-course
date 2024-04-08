// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverterV1.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    using PriceConverter for uint256;

    error NotOwner();


    address public immutable i_owner;
    uint256 public constant MINIMUM_USD = 5e18;
    address[] public listOfFunders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    constructor() {
        i_owner = msg.sender;
    }

    modifier isOwner {
        if(msg.sender != i_owner) { revert NotOwner(); }
        _;
    }
    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD);
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

    function getVersion() external view returns(uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}