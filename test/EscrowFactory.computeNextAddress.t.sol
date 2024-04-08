// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

import {EscrowFactoryFixture} from "./fixtures/EscrowFactoryFixture.sol";

import {Escrow} from "src/Escrow.sol";
import {IEscrow} from "src/interfaces/IEscrow.sol";

address constant SELLER_ADDR = address(1001);
address constant ARBITER_ADDR = address(1002);
address constant ZERO_ADDR = address(0);

uint256 constant ESCROW_VALUE = 1e6;
bytes32 constant SALT = "1234";

contract EscrowFactoryComputeNextAddressTest is EscrowFactoryFixture {
    function setUp() public {
        loadFixture();
    }

    function test_correctAddress() public {
        address nextEscrowAddress = vm.computeCreate2Address(
            SALT,
            keccak256(
                abi.encodePacked(
                    type(Escrow).creationCode,
                    abi.encode(defaultSender, SELLER_ADDR, ARBITER_ADDR, mockToken, ESCROW_VALUE)
                )
            ),
            address(escrowFactory)
        );
        IEscrow escrow = escrowFactory.createEscrow(SELLER_ADDR, ARBITER_ADDR, mockToken, ESCROW_VALUE, SALT);

        vm.assertEq(address(escrow), nextEscrowAddress);
    }
}
