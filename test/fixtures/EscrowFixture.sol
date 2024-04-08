// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {EscrowFactoryFixture} from "./EscrowFactoryFixture.sol";
import {TestExtended} from "../utils/TestExtended.sol";

import {EscrowFactory} from "src/EscrowFactory.sol";
import {MockToken} from "src/mocks/MockToken.sol";
import {IEscrow} from "src/interfaces/IEscrow.sol";

contract EscrowFixture is TestExtended {
    EscrowFactory escrowFactory;
    MockToken mockToken;

    IEscrow escrow;

    uint256 constant SENDER_BALANCE = 1e9;

    address constant SELLER_ADDR = address(1001);
    address constant ARBITER_ADDR = address(1002);
    address constant RANDOM_ADDR = address(123654);
    address constant ZERO_ADDR = address(0);

    uint256 constant ESCROW_VALUE = 1e6;
    bytes32 constant SALT = "1234";
    bytes32 constant SALT2 = "2345";

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
