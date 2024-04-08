/* 
Instructions

Write a contract that 
1. Inherits the SimpleStorage contract
2. Overrides the store function in the SimpleStorage contract
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {SimpleStorage} from "./01SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage {

    function store(uint256 _newFavoriteNumber) public override {
        myFavoriteNumber = _newFavoriteNumber + 5;
    }
}