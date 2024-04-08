// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {EscrowFixture} from "./fixtures/EscrowFixture.sol";

import {EscrowStatus} from "src/interfaces/IEscrow.sol";

contract EscrowConfirmTransactionTest is EscrowFixture {
    event Confirmed();
    event Denied();
    event Resolved();

    function setUp() public {
        loadFixture();
    }

    function test_RevertOn_ArbiterCall() public from(ARBITER_ADDR) {
        expectRevert("Not a buyer or seller");
        escrow.denyTransaction();
    }

    function test_RevertOn_RandomAddrCall() public from(RANDOM_ADDR) {
        expectRevert("Not a buyer or seller");
        escrow.denyTransaction();
    }

    function test_RevertOn_ConfirmedStatus() public {
        escrow.confirmTransaction();

        expectRevert("Unexpected escrow status");
        escrow.denyTransaction();
    }

    function test_RevertOn_DeniedStatus() public {
        escrow.denyTransaction();

        expectRevert("Unexpected escrow status");
        escrow.denyTransaction();
    }

    function test_RevertOn_ResolvedStatus() public {
        escrow.denyTransaction();

        vm.startPrank(ARBITER_ADDR);
        escrow.resolveDispute(0);
        vm.stopPrank();

        vm.startPrank(defaultSender);
        expectRevert("Unexpected escrow status");
        escrow.denyTransaction();
    }

    function test_SellerCall() public from(SELLER_ADDR) {
        escrow.denyTransaction();
    }

    function test_SetStatus() public {
        escrow.denyTransaction();
        vm.assertTrue(escrow.status() == EscrowStatus.Denied);
    }

    function test_EmitEvent() public {
        expectEmit();
        emit Denied();
        escrow.denyTransaction();
    }
}
