// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {FundMe} from "../src/FundMe.sol";


contract FundMeTest is Test {
    uint number = 1;
    FundMe fm;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();

        fm = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
        number = 2;
    }

    function testDemo() public view {
        console.log("Hello");
        console.log(number);
        assertEq(number, 2);
    }

    function testMinDollar() public view {
        assertEq(fm.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        console.log(fm.getOwner());
        console.log(msg.sender);
        console.log(address(this));
        // assertEq(fm.i_owner(), address(this));
        assertEq(fm.getOwner(), msg.sender); // works in lesson but not here. didn't originally update the setUp function
    }

    // forge test --match-test testPriceFeedVersionIsAccurate
    function testPriceFeedVersionIsAccurate() public view {
        
        uint256 version = fm.getVersion();
        if (block.chainid == 1){
            assertEq(version, 6);
        } else {
            assertEq(version, 4);
        }
        
    
    }

    // https://book.getfoundry.sh/forge/cheatcodes
    function testFundsFailsWithoutEnoughETH() public {
        
        vm.expectRevert();
        fm.fund();

    }

    function testFundUpdatesFundedDataStructure() public {
        
        vm.prank(USER);
        fm.fund{value: SEND_VALUE}();
        
        uint256 amountFunded = fm.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fm.fund{value: SEND_VALUE}();

        assertEq(fm.getFunder(0), USER); 
        
    }
    modifier funded(){
        vm.prank(USER);
        fm.fund{value: SEND_VALUE}();
        _;
    }
    function testOnlyOwnerCanWithdraw() public funded {
        // replaced with modifier
        // vm.prank(USER);
        // fm.fund{value: SEND_VALUE}();

        vm.expectRevert();
        vm.prank(USER); // USER isn't contract owner. "withdraw" has onlyOwner modifer
        fm.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fm.getOwner().balance;
        uint256 startingFundMeBalancec = address(fm).balance;

        // Act
        vm.prank(fm.getOwner());
        fm.withdraw();

        // Assert
        uint256 endingOwnerBalance = fm.getOwner().balance;
        uint256 endingFundMeBalance = address(fm).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingOwnerBalance + startingFundMeBalancec, endingOwnerBalance);

    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++){
            // does vm.prank & vm.deal 
            hoax(address(i), SEND_VALUE);
            fm.fund{value:SEND_VALUE}();
        }

        uint startingOwnerBalance = fm.getOwner().balance;
        uint startingFundMeBalance = address(fm).balance;

        vm.startPrank(fm.getOwner());
        fm.withdraw();
        vm.stopPrank();

        uint endingFundMeBalance = address(fm).balance;
        uint endingOwnerBalance = fm.getOwner().balance;

        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
        assertEq(endingFundMeBalance, 0);


    }
}
