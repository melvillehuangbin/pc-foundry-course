// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// import directly friom github https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    // Concept 1
    // function fund() public payable { // payable keyword allows contract addresses to receive ETH and store
    //     // Create a function that allow users to send $
    //     // Have a minimum $ sent
    //     // 1. How do we send Eth to this contract?
    //     require(msg.value > 1 ether, "didnt sent enough");
    // }

    // Concept 2
    // Create a function that allow user to send $
    // Users need to senda minimum of $5 USD
    // Convert the $5 from USD to ethereum
    // To do that, we need to use something known as a decentralized oracle
    // As the value of Ether is something we as humans assigned
    // In a web2 environment, usually we would do an API call to retrive that data
    // However if do we that in our smart contracts, nodes will never be able to reach consensus
    // Chainlink - decentralized oracle network
    // High Level Concept of How Chain Link Works - many different nodes sign their data and send it to a single node, which delivers that data to a smart contract on the chainlink network that can then be referenced by smart contracts from external networks

    uint256 minimumUsd = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable {
        // provide funds to the message sender
        require(getConversionRate(msg.value) >= minimumUsd, "didnt sent enough");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;

    }


    // function to get price 
    function getPrice() public view returns(uint256) {
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        (,int256 answer,,,) = pricefeed.latestRoundData();
        // price of ETH in terms of USD
        // 2000.00000000
        return uint256(answer * 1e10);
    }
    // interfaces will provide you with all the code in the addressed reference
    // Interface(address);
    // Doing so will allow you to call any functions at that address

    // function to convert price
    function getConversionRate(uint256 _ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethPriceInUsd = (ethPrice * _ethAmount) / 1e18;
        return ethPriceInUsd;
    }

    // function to get version of interface
    function getVersion() public view returns(uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

}