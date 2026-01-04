// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract FundMe {

    uint public myVal = 1;
    uint public minUSD = 5; // Sample Chainlink datafeed https://docs.chain.link/data-feeds/getting-started

    function fund() public payable {
        myVal = myVal + 2;

        require(msg.value > minUSD, "some message from Leo: didn't send enough ETH");
    }

    function withdraw() public {

    }
}