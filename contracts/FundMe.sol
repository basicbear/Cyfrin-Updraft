// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts@1.5.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint public myVal = 1;
    uint public minUSD = 5e18; // Sample Chainlink datafeed https://docs.chain.link/data-feeds/getting-started

    AggregatorV3Interface internal dataFeed;
    
    address[] public funderz;
    mapping(address funder => uint amtFunded) public addr2AmtFunded;

    constructor() {
        dataFeed = AggregatorV3Interface(0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43);
    }

    function fund() public payable {
        myVal = myVal + 2;
        // https://docs.soliditylang.org/en/latest/units-and-global-variables.html#block-and-transaction-properties
        require(getConversionRate(msg.value) > minUSD, "some message from Leo: didn't send enough ETH");
        funderz.push(msg.sender);
        addr2AmtFunded[msg.sender] += msg.value;
    }

    function withdraw() public {

    }

    function getPrice() public view returns (uint) {
        // https://docs.chain.link/data-feeds/api-reference#latestrounddata
        // uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound
        (, int256 price ,,,) = dataFeed.latestRoundData();

        return uint(price * 1e10);
    }

    function getConversionRate(uint ethAmount) public view returns(uint){
        
        uint ethPrice = getPrice();
        uint usdAmt = (ethPrice * ethAmount) / 1e18;
        return usdAmt;
    }

    function getVersion() public view returns (uint) {
        return dataFeed.version();
    }
}