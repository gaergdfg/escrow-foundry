// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import {EscrowFactoryFixture} from "./fixtures/EscrowFactoryFixture.sol";

import {Escrow} from "src/Escrow.sol";
import {IEscrow, EscrowStatus} from "src/interfaces/IEscrow.sol";

contract EscrowFactoryCreateEscrowTest is EscrowFactoryFixture {
    event EscrowCreated(
        address escrowContract, address buyer, address seller, address arbiter, IERC20 token, uint256 value
    );

    function setUp() public {
        loadFixture();
    }

    function test_RevertOn_InvalidSeller() public {
        expectRevert("Invalid seller address");
        escrowFactory.createEscrow(ZERO_ADDR, ARBITER_ADDR, mockToken, ESCROW_VALUE, SALT);
    }

    function test_RevertOn_InvalidAbiter() public {
        expectRevert("Invalid arbiter address");
        escrowFactory.createEscrow(SELLER_ADDR, ZERO_ADDR, mockToken, ESCROW_VALUE, SALT);
    }

    function test_RevertOn_ZeroValue() public {
        expectRevert("Value cannot be zero");
        escrowFactory.createEscrow(SELLER_ADDR, ARBITER_ADDR, mockToken, 0, SALT);
    }

    function test_SetFields() public {
        IEscrow escrow = escrowFactory.createEscrow(SELLER_ADDR, ARBITER_ADDR, mockToken, ESCROW_VALUE, SALT);

        vm.assertEq(escrow.buyer(), defaultSender);
        vm.assertEq(escrow.seller(), SELLER_ADDR);
        vm.assertEq(escrow.arbiter(), ARBITER_ADDR);
        vm.assertEq(address(escrow.token()), address(mockToken));
        vm.assertEq(escrow.value(), ESCROW_VALUE);
        assertTrue(escrow.status() == EscrowStatus.Created);
    }

    function test_TransferTokens() public {
        IEscrow escrow = escrowFactory.createEscrow(SELLER_ADDR, ARBITER_ADDR, mockToken, ESCROW_VALUE, SALT);
        vm.assertEq(mockToken.balanceOf(address(escrow)), ESCROW_VALUE);
    }

    function test_EmitEvent() public {
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

        expectEmit();
        emit EscrowCreated(nextEscrowAddress, defaultSender, SELLER_ADDR, ARBITER_ADDR, mockToken, ESCROW_VALUE);
        escrowFactory.createEscrow(SELLER_ADDR, ARBITER_ADDR, mockToken, ESCROW_VALUE, SALT);
    }
}
