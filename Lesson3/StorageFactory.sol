// SPDX-License-Identifier: MIT

pragma solidity 0.8.19; // make sure to note versions of contracts when using imports 

import {SimpleStorage} from "./SimpleStorage.sol"; // always referring to name imports is a best practice

// new contract StorageFactory should interact with SimpleStorage contract 
contract StorageFactory{
    
    // type visibility name
    // uint256 public favoriteNumber

    // SimpleStorage = contract, simpleStorage = variable
    SimpleStorage[] public listOfSimpleStorageContracts;


    // create new SimpleStorage contract
    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorageContract = new SimpleStorage(); // new keyword tells solidity to deploy new contract
        listOfSimpleStorageContracts.push( newSimpleStorageContract ); 
    }

    // function sfStore to store a new number in a contract from a list of contracts
    function sfStore(uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public {
        // Address
        // ABI - Application Binary Interface
        // ABI is a human-readable list of methods on a smart contract for executing particular functions
        SimpleStorage newSimpleContract = listOfSimpleStorageContracts[_simpleStorageIndex];
        newSimpleContract.store(_newSimpleStorageNumber);
    }

    // function sfGet to retrive a new number in a contract from a list of contracts
    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256) {
        return listOfSimpleStorageContracts[_simpleStorageIndex].retrieve();
    }

}