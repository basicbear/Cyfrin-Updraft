// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage {
    function sayHello() public pure returns(string memory){
        return "LEO";
    }

    function store(uint256 _newNum) public override {
        super.store(_newNum + 5);
    }

}