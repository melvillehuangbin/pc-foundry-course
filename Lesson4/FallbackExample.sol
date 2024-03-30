// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract FallBackExample {

    uint256 public result;
    receive() external payable {
        result = 1;
    }

    fallback() external payable {
        result = 2;
    }
}


// Explaining special functions fallback() and receive()
// Ether is sent to contract
//              is msg.data empty?
//                  /       \
//              yes          no
//              /               \
//             receive()         fallback()
//              /    \ 
//             yes  no
//             /     \
//          receive() fallback()        