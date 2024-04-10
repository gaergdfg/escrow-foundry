// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {EscrowFixture} from "./fixtures/EscrowFixture.sol";

import {EscrowStatus} from "src/interfaces/IEscrow.sol";

contract EscrowConfirmTransactionTest is EscrowFixture {
    event Confirmed();

    function setUp() public {
        loadFixture();
    }

    function test_RevertOn_SellerCall() public from(SELLER_ADDR) {
        expectRevert("Not a buyer");
        escrow.confirmTransaction();
    }

    function test_RevertOn_ArbiterCall() public from(ARBITER_ADDR) {
        expectRevert("Not a buyer");
        escrow.confirmTransaction();
    }

    function test_RevertOn_RandomAddrCall() public from(RANDOM_ADDR) {
        expectRevert("Not a buyer");
        escrow.confirmTransaction();
    }

    function test_RevertOn_ConfirmedStatus() public {
        escrow.confirmTransaction();

        expectRevert("Unexpected escrow status");
        escrow.confirmTransaction();
    }

    function test_RevertOn_DeniedStatus() public {
        escrow.denyTransaction();

        expectRevert("Unexpected escrow status");
        escrow.confirmTransaction();
    }

    function test_RevertOn_ResolvedStatus() public {
        escrow.denyTransaction();

        vm.startPrank(ARBITER_ADDR);
        escrow.resolveDispute(0);
        vm.stopPrank();

        vm.startPrank(defaultSender);
        expectRevert("Unexpected escrow status");
        escrow.confirmTransaction();
    }

    function test_TransferTokens() public {
        escrow.confirmTransaction();

        vm.assertEq(mockToken.balanceOf(SELLER_ADDR), ESCROW_VALUE);
    }

    function test_SetStatus() public {
        escrow.confirmTransaction();
        vm.assertTrue(escrow.status() == EscrowStatus.Confirmed);
    }

    function test_EmitEvent() public {
        expectEmit();
        emit Confirmed();
        escrow.confirmTransaction();
    }
}
