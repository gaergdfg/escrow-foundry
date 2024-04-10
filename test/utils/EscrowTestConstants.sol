// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract EscrowTestConstants {
    address constant SELLER_ADDR = address(1001);
    address constant ARBITER_ADDR = address(1002);
    address constant RANDOM_ADDR = address(123654);
    address constant ZERO_ADDR = address(0);

    uint256 constant ESCROW_VALUE = 1e6;
    bytes32 constant SALT = "1234";
    bytes32 constant SALT2 = "2345";
}
