// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fm;

    address alice = makeAddr("alice");
    uint256 constant SEND_VALUE = 0.2 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fm = deploy.run();
        vm.deal(alice, STARTING_BALANCE);
    }

    function testUserCanFundInteractions() public {
        
        // FundFundMe ffm = new FundFundMe();
        vm.prank(alice);
        fm.fund{value: SEND_VALUE}();
        // vm.deal(alice, 2e18);
        console.log("BEAR fundMe bal: ",address(fm).balance);
        // ffm.fundFundMe(address(fm));
        console.log("BEAR fundMe bal: ",address(fm).balance);

        address funder = fm.getFunder(0);
        assertEq(funder, alice);

        WithdrawFundMe wfm = new WithdrawFundMe();
        wfm.withdrawFundMe(address(fm));

        assert(address(fm).balance == 0);
    }
}