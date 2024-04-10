// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

import {IEscrow, EscrowStatus} from "./interfaces/IEscrow.sol";

contract Escrow is IEscrow {
    using SafeERC20 for IERC20;

    address public immutable buyer;
    address public immutable seller;
    address public immutable arbiter;

    IERC20 public immutable token;
    uint256 public immutable value;

    EscrowStatus public status;

    constructor(address _buyer, address _seller, address _arbiter, IERC20 _token, uint256 _value) {
        require(_seller != address(0), "Invalid seller address");
        require(_arbiter != address(0), "Invalid arbiter address");
        require(_token.balanceOf(address(this)) >= _value, "Insufficient funds");

        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;

        token = _token;
        value = _value;

        status = EscrowStatus.Created;
    }

    function confirmTransaction() external {
        require(msg.sender == buyer, "Not a buyer");
        require(status == EscrowStatus.Created, "Unexpected escrow status");

        status = EscrowStatus.Confirmed;
        emit Confirmed();

        token.safeTransfer(seller, value);
    }

    function denyTransaction() external {
        require(msg.sender == buyer || msg.sender == seller, "Not a buyer or seller");
        require(status == EscrowStatus.Created, "Unexpected escrow status");

        status = EscrowStatus.Denied;
        emit Denied();
    }

    function resolveDispute(uint256 buyerReimbursement) external {
        require(msg.sender == arbiter, "Not an arbiter");
        require(status == EscrowStatus.Denied, "Unexpected escrow status");

        uint256 totalBalance = token.balanceOf(address(this));
        require(buyerReimbursement <= totalBalance, "Reimbursement exceeds balance");

        status = EscrowStatus.Resolved;
        emit Resolved(buyerReimbursement);

        if (buyerReimbursement > 0) {
            token.safeTransfer(buyer, buyerReimbursement);
        }

        uint256 remainingBalance = token.balanceOf(address(this));
        if (remainingBalance > 0) {
            token.safeTransfer(seller, remainingBalance);
        }
    }
}
