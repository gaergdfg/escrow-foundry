// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import {IEscrow} from "./IEscrow.sol";

interface IEscrowFactory {
    event EscrowCreated(
        address escrowContract, address buyer, address seller, address arbiter, IERC20 token, uint256 value
    );

    function createEscrow(address seller, address arbiter, IERC20 token, uint256 value, bytes32 salt)
        external
        returns (IEscrow);
}
