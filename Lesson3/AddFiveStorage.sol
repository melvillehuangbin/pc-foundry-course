// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

// inheritance: inherting another contract 
contract AddFiveStorage is SimpleStorage {

    // overrides another function
    // keywords: virtual override
    // virtual keyword must be included in the base function to be overided
    
    // write a function to store a new number with more than five 
    function store(uint256 _newNumber) public override {
        myFavoriteNumber = _newNumber + 5;
    }
}