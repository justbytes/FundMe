pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeoployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 1 ether;
    uint256 constant STARTING_BALANCE = 100 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    // function testMinimumDollarIsFive() public view {
    //     assertEq(fundMe.MINIMUM_USD(), 5e18);
    // }

    // function testOwnerIsMsgSender() public view {
    //     assertEq(fundMe.i_owner(), msg.sender);
    // }

    // function testPriceFeedVersionIsAccurate() public view {
    //     uint256 version = fundMe.getVersion();
    //     assertEq(version, 4);
    // }

    // function testFundFailsWithoutEnoughETH() public {
    //     vm.expectRevert();
    //     fundMe.fund();
    // }

    // function testPriceFeedIsWorking() public view {
    //     (, int256 price, , , ) = fundMe.getPriceFeed().latestRoundData();
    //     assertGt(price, 0); // Price should be greater than 0
    // }
    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);

        // Log min USD requirement
        console.log("Minimum USD required:", fundMe.MINIMUM_USD());

        // Log ETH price from feed
        (, int256 price, , , ) = fundMe.getPriceFeed().latestRoundData();
        console.log("ETH/USD price from feed:", uint256(price));

        // Log the value we're sending
        console.log("Sending ETH value:", SEND_VALUE);

        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }
}
