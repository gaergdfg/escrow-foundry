// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {EscrowFixture} from "./fixtures/EscrowFixture.sol";

import {IEscrow, EscrowStatus} from "src/interfaces/IEscrow.sol";

uint256 constant BUYER_REIMBURSEMENT = 182743;

contract EscrowResolveDisputeTest is EscrowFixture {
    event Confirmed();
    event Denied();
    event Resolved(uint256 buyerReimbursement);

    function setUp() public {
        loadFixture();
        escrow.denyTransaction();
    }

    function test_RevertOn_BuyerCall() public {
        expectRevert("Not an arbiter");
        escrow.resolveDispute(0);
    }

    function test_RevertOn_SellerCall() public from(SELLER_ADDR) {
        expectRevert("Not an arbiter");
        escrow.resolveDispute(0);
    }

    function test_RevertOn_RandomAddrCall() public from(RANDOM_ADDR) {
        expectRevert("Not an arbiter");
        escrow.resolveDispute(0);
    }

    function test_RevertOn_CreatedStatus() public {
        IEscrow newEscrow = escrowFactory.createEscrow(SELLER_ADDR, ARBITER_ADDR, mockToken, ESCROW_VALUE, SALT2);

        vm.startPrank(ARBITER_ADDR);
        expectRevert("Unexpected escrow status");
        newEscrow.resolveDispute(0);
    }

    function test_RevertOn_ConfirmedStatus() public {
        IEscrow newEscrow = escrowFactory.createEscrow(SELLER_ADDR, ARBITER_ADDR, mockToken, ESCROW_VALUE, SALT2);
        newEscrow.confirmTransaction();

        vm.startPrank(ARBITER_ADDR);
        expectRevert("Unexpected escrow status");
        newEscrow.resolveDispute(0);
    }

    function test_RevertOn_ResolvedStatus() public {
        IEscrow newEscrow = escrowFactory.createEscrow(SELLER_ADDR, ARBITER_ADDR, mockToken, ESCROW_VALUE, SALT2);
        newEscrow.denyTransaction();

        vm.startPrank(ARBITER_ADDR);
        newEscrow.resolveDispute(0);

        expectRevert("Unexpected escrow status");
        newEscrow.resolveDispute(0);
    }

    function test_RevertOn_ReimbursementExceedsBalance() public from(ARBITER_ADDR) {
        expectRevert("Reimbursement exceeds balance");
        escrow.resolveDispute(ESCROW_VALUE + 1);
    }

    function test_TransferTokens() public from(ARBITER_ADDR) {
        escrow.resolveDispute(BUYER_REIMBURSEMENT);
        uint256 sellerReimbursement = ESCROW_VALUE - BUYER_REIMBURSEMENT;
        uint256 newBuyerBalance = SENDER_BALANCE - ESCROW_VALUE + BUYER_REIMBURSEMENT;

        vm.assertEq(mockToken.balanceOf(defaultSender), newBuyerBalance, "Buyer balance mismatch");
        vm.assertEq(mockToken.balanceOf(SELLER_ADDR), sellerReimbursement, "Seller balance mismatch");
    }

    function test_SetStatus() public from(ARBITER_ADDR) {
        escrow.resolveDispute(0);
        vm.assertTrue(escrow.status() == EscrowStatus.Resolved);
    }

    function test_EmitEvent() public from(ARBITER_ADDR) {
        expectEmit();
        emit Resolved(BUYER_REIMBURSEMENT);
        escrow.resolveDispute(BUYER_REIMBURSEMENT);
    }
}
