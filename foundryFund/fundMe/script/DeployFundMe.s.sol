// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {Test, console} from "forge-std/Test.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {

    function run() external returns (FundMe) {

        // before "startBroadcast" => mocked trx
        HelperConfig hc = new HelperConfig();
        
        address ethUsdPriceFeed = hc.activeNetworkConfig();

        console.log("BEAR: DeployFundMe ", ethUsdPriceFeed);
        vm.startBroadcast(); // After this => Real trx!
        
        FundMe fm = new FundMe(ethUsdPriceFeed);
        
        vm.stopBroadcast();

        return fm;

    }

}