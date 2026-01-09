// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    uint number = 1;
    FundMe fm;

    function setUp() external {
        fm = new FundMe();
        number = 2;
    }

    function testDemo() public view {
        console.log("Hello");
        console.log(number);
        assertEq(number, 2);
    }

    function testMinDollar() public view {
        assertEq(fm.MINIMUM_USD(), 6e18);
    }
}
