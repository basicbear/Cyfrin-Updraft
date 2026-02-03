// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract SafeMathTester {
    uint8 public bigNum = 255;

    function plus1() public {
        unchecked {
            bigNum +=1;
        }
        
    }
}