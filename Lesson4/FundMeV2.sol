// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// we can also create custom errors 
// this are pretty new in solidity so require() is still used pretty often currently
error NotOwner();

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {

    // using a library
    using PriceConverter for uint256;

    // using libraries
    // datatype.method(), the variable of the correct datatype will pass itself into the method arguments

    address public immutable i_owner;

    // constructor: immediately called when contract is deployed
    constructor() {
        i_owner = msg.sender;
    }

    // function to fund users
    // user to request for a minimum of $5 Usd worth of ETH

    uint256 public constant MINIMUM_USD = 50 * 1e18;
    address[] public listOfFunders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD,  "didnt send enough ETH"); // if there are many different arguments in the method, the initial argument will be the one where the variable pass itself into
        listOfFunders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    // function for users to withdraw funds
    // we only want the owner of the contract to be able to withdraw the funds
    
    // for each funder,
    // 1. get the address of the funder
    // 2. set the amount funded by the funder back to 0
    // 3. reset the array
    // 4. withdraw the funds - to be cast to payable type
    //  - transfer: fails when gas is exceeded
    //  - send: returns boolean
    //  - call: low level, returns two values successBoolean, dataReturned

    function withdraw() public onlyOwner {
        for(uint256 funderIndex=0; funderIndex < listOfFunders.length; funderIndex++ ) {
            address funderAddress = listOfFunders[funderIndex];
            addressToAmountFunded[funderAddress] = 0;
        }
        listOfFunders = new address[](0);

        // transfer
        // payable(msg.sender).transfer(address(this).balance);
        
        // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Call failed");

        // call (low level)
        (bool sendSuccess, /* bytes memory dataReturned */) = payable(msg.sender).call{value: address(this).balance}("");
        require(sendSuccess, "Called Failed");
    }

    // reusable code snippets
    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not owner");
        if(msg.sender != i_owner) { revert NotOwner();}
        _; // execute code here
    }

    // tricks to reduce Gas cost
    // constant keyword
    //  - name the keyword in ALL CAPS with underscores
    // immutable
    //  - name the variable i_x

    // What happens if someone sends this contract ETH without calling the fund function?
    // We can call fund() function in both receive and fallback special functions
    // receive()

    receive() external payable {
        fund();
    }
    // fallback()
    fallback() external payable {
        fund();
    }
}