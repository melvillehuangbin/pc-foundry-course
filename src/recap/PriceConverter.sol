// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns(uint256) {
        (, int256 answer, , ,) = priceFeed.latestRoundData();
        return uint256(answer * 1e10);
    }

    function getConversionRate(
        uint256 etherPrice,
        AggregatorV3Interface priceFeed
    ) internal view returns(uint256) {
        return (etherPrice * getPrice(priceFeed)) / 1e18;
    }
}