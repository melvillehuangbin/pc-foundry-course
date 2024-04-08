/*
Instructions:

Create a contract that does the following:
1. Has a function that creates a new SimpleStorage contract and pushes the new contract to a list of SimpleStorage contracts
2. Has a function that takes in an index to retreive one of the contracts and store a number pass in as a parameter
3. Has a function to get the favorite number from the list of SimpleStorage contracts

 */

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {SimpleStorage} from "./01SimpleStorage.sol";

contract StorageFactory {


    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract() public {
        SimpleStorage _simpleStorage = new SimpleStorage();
        listOfSimpleStorageContracts.push(_simpleStorage);
    }

    function retrieveSimpleStorageContract(uint256 _simpleStorageIndex, uint256 _favoriteNumber) public {
        SimpleStorage _simpleStorageContract = listOfSimpleStorageContracts[_simpleStorageIndex];
        _simpleStorageContract.store(_favoriteNumber);
    }

    function getSimpleStorageContractAddress(uint256 _simpleStorageIndex) public view returns(uint256) {
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }
}