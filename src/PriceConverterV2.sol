// SPDX-License-Identifier: MIT

/* 
Notes:

Objective: Refactor code such that the contract will use the address we want to pass in for the pricefeed

1. pass in an interface priceFeed into the getPrice() and getConversionRate() function to retrieve latest data

*/

pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns(uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer * 1e10); 
    }

    function getConversionRate(
        uint256 _currentEtherPrice,
        AggregatorV3Interface priceFeed
    ) internal view returns(uint256) {
        return (getPrice(priceFeed) * _currentEtherPrice) / 1e18;
    }

}