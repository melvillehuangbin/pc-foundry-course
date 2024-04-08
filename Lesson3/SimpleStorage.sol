// EVM, Ethereum Virtual Machine
// Ethereum, Polygon, Arbitrum, Optimisim, Zksync

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19; // solidity versions

contract SimpleStorage { // contract is similar to a class
    // Studying Basic Types: boolean, uint, int, address, bytes
    // bool hasFavoriteNumber = false;
    // uint256 favoriteNumber = 88;
    // int256 favouriteNumber = -88; // integers can be negative
    // string favoriteNumberInText = "88";
    // address myAddress = 0x0168438c6c5D381Af5FD56ca6FAe54295c25BE7F;
    // bytes32 favoriteBytes32 = "cat";

    // favoriteNumber is a "storage" variable
    uint256 myFavoriteNumber; // defaulted to 0 and visibility to internal
    // uint256 public favoriteNumber; // getter and setter created for this variable set to public
    
    // uint256[] listOfFavoriteNumbers; // [0, 78, 90]
    struct Person{
        uint256 favoriteNumber;
        string name;
    }

    // dynamic array: size can grow or shrink
    Person[] public listOfPeople;

    // static array: fix size
    // Person[3] public listOfPeople;

    // Person public pat = Person({favoriteNumber: 7, name: "Pat"});

    // mapping types: something like a dictionary
    mapping(string => uint256) public nameToFavoriteNumber;


    // store a new favorite number
    function store(uint256 _favoriteNumber) public virtual {
        myFavoriteNumber = _favoriteNumber;
    }

    // view, pure: notates functions that dont actually have to run or send transactions in order for you to call them
    // view: disallow modifying state
    // a view actually costs gas if another function that does cost gas calls it then it will cost something
    function retrieve() public view returns(uint256) {
        // myFavoriteNumber = favoriteNumber + 1; // view prevents state modifications
        return myFavoriteNumber;
    }

    // pure: disallow reading storage variable (state) or modifying state
    // function retrieve() public pure returns(uint256) {
    //     return 7;
    // }


    // EVM can access and store information in six places
    // 1. Stack
    // 2. Memory - temporary variables that allows for modification of state
    // 3. Storage - permanent variables created outside of function and inside of contract. allows for modification of state.
    // 4. Calldata - temporary variables that does not allow for modification of state
    // 5. Code 
    // 6. Logs

    // _name can only be access once in the function
    // string requires memory keyword
    // uint256 does not require the memory keyword
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        // Person memory new_person = Person(_favoriteNumber, _name);
        listOfPeople.push( Person(_favoriteNumber, _name) );
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

    // Contract Address 0xd9145CCE52D386f254917e481eB44e9943F39138

    // Input Data: 0x608060405234801561001057600080fd5b5060e38061001f6000396000f3fe6080604052348015600f57600080fd5b506004361060285760003560e01c80636057361d14602d575b600080fd5b60436004803603810190603f91906085565b6045565b005b8060008190555050565b600080fd5b6000819050919050565b6065816054565b8114606f57600080fd5b50565b600081359050607f81605e565b92915050565b6000602082840312156098576097604f565b5b600060a4848285016072565b9150509291505056fea2646970667358221220f0a333abe965f6df794408e21b8cd99b378e4596bf2b7372a4da56926d40ab1864736f6c63430008130033
}

// smart contracts being able to interact with each other is known as composability