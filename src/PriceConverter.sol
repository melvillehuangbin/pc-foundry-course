// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    // function to get price 
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns(uint256) {
        (,int256 answer,,,) = priceFeed.latestRoundData();
        // price of ETH in terms of USD
        // 2000.00000000
        return uint256(answer * 1e10);
    }
    // interfaces will provide you with all the code in the addressed reference
    // Interface(address);
    // Doing so will allow you to call any functions at that address

    // function to convert price
    function getConversionRate(
        uint256 _ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns(uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethPriceInUsd = (ethPrice * _ethAmount) / 1e18;
        return ethPriceInUsd;
    }

    // function to get version of interface
    function version(
        AggregatorV3Interface priceFeed        
    ) internal view returns(uint256) {
        return priceFeed.version();
    }
}