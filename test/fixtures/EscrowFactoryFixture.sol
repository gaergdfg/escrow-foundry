// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {EscrowFactoryHarness} from "../harnesses/EscrowFactoryHarness.sol";
import {EscrowTestConstants} from "../utils/EscrowTestConstants.sol";
import {TestExtended} from "../utils/TestExtended.sol";

import {MockToken} from "src/mocks/MockToken.sol";

contract EscrowFactoryFixture is TestExtended, EscrowTestConstants {
    EscrowFactoryHarness escrowFactory;
    MockToken mockToken;

    uint256 constant SENDER_BALANCE = 1e9;

    function loadFixture() internal {
        escrowFactory = new EscrowFactoryHarness();
        mockToken = new MockToken();

        mockToken.transfer(defaultSender, SENDER_BALANCE);
        vm.prank(defaultSender);
        mockToken.approve(address(escrowFactory), SENDER_BALANCE);

        vm.startPrank(defaultSender);
    }
}
