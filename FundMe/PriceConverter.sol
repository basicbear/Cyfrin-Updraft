// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts@1.5.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

    function getPrice() internal view returns (uint) {

        AggregatorV3Interface dataFeed = AggregatorV3Interface(0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43);
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
        AggregatorV3Interface dataFeed = AggregatorV3Interface(0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43);
        return dataFeed.version();
    }

}