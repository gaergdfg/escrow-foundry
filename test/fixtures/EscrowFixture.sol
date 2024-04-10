// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {EscrowFactoryFixture} from "./EscrowFactoryFixture.sol";
import {EscrowTestConstants} from "../utils/EscrowTestConstants.sol";
import {TestExtended} from "../utils/TestExtended.sol";

import {EscrowFactory} from "src/EscrowFactory.sol";
import {MockToken} from "src/mocks/MockToken.sol";
import {IEscrow} from "src/interfaces/IEscrow.sol";

contract EscrowFixture is TestExtended, EscrowTestConstants {
    EscrowFactory escrowFactory;
    MockToken mockToken;

    IEscrow escrow;

    uint256 constant SENDER_BALANCE = 1e9;

    function loadFixture() internal {
        escrowFactory = new EscrowFactory();
        mockToken = new MockToken();

        mockToken.transfer(defaultSender, SENDER_BALANCE);
        vm.prank(defaultSender);
        mockToken.approve(address(escrowFactory), SENDER_BALANCE);

        vm.startPrank(defaultSender);

        escrow = escrowFactory.createEscrow(SELLER_ADDR, ARBITER_ADDR, mockToken, ESCROW_VALUE, SALT);
    }
}
