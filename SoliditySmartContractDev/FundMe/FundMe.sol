// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { PriceConverter } from "./PriceConverter.sol";

contract FundMe {

    uint public myVal = 1;
    uint public constant minUSD = 5e18; // Sample Chainlink datafeed https://docs.chain.link/data-feeds/getting-started

    // AggregatorV3Interface internal dataFeed;
    
    address[] public funderz;
    mapping(address funder => uint amtFunded) public addr2AmtFunded;

    using PriceConverter for uint;

    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable {
        myVal = myVal + 2;
        // https://docs.soliditylang.org/en/latest/units-and-global-variables.html#block-and-transaction-properties
        require(msg.value.getConversionRate() > minUSD, "some message from contract: didn't send enough ETH");
        funderz.push(msg.sender);
        addr2AmtFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        require(msg.sender == i_owner, "FundMe__NotOwner");

        for (uint i = 0; i < funderz.length; i++) 
        {
            address funder = funderz[i];
            addr2AmtFunded[funder] = 0;
        }
        
        funderz = new address[](0);

        // payable(msg.sender).transfer(address(this).balance);

        // bool sendSucc = payable(msg.sender).send(address(this).balance);
        // require(sendSucc,"send failed");

        (bool callSucc, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSucc, "call failed");



    }
    
    modifier onlyOwner {
        // require(msg.sender == i_owner, "FundMe__NotOwner");
        if(msg.sender != i_owner) revert NotOwner();
        _;
    }

    // Default functions : Receive, Fallback 
    // https://docs.soliditylang.org/en/latest/contracts.html#special-functions

    receive() external payable { fund(); }
    fallback() external payable { fund(); }

}

error NotOwner();