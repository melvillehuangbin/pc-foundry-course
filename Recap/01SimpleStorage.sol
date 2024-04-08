// Instructions
// Create a contract, called SimpleStorage, that is able to do the following:
// 1. a function that stores and override a value called myFavoriteNumber
// 2. a function that retrieves the variable myFavoriteNumber with the number you past in
// 3. a function that allows the contract to add a new Person to a list of Persons. Each person should be a struct with the variables favoriteNumber and name

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract SimpleStorage {

    uint256 public myFavoriteNumber;

    struct Person {
        uint256 _favoriteNumber;
        string _name;
    }

    Person[] public listOfPersons;

    mapping(string _name => uint256 _favoriteNumber) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public virtual {
        myFavoriteNumber = _favoriteNumber;
    }   

    function retrieve() public view returns(uint256) {
        return myFavoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        listOfPersons.push( Person(_favoriteNumber, _name) );
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

}