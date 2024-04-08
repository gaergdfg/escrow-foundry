// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

enum EscrowStatus {
    Created,
    Confirmed,
    Denied,
    Resolved
}

interface IEscrow {
    event Confirmed();
    event Denied();
    event Resolved(uint256 buyerReimbursement);

    function confirmTransaction() external;

    function denyTransaction() external;

    function resolveDispute(uint256 buyerReimbursement) external;

    function buyer() external returns (address);

    function seller() external returns (address);

    function arbiter() external returns (address);

    function token() external returns (IERC20);

    function value() external returns (uint256);

    function status() external returns (EscrowStatus);
}
