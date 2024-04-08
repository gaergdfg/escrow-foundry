// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {EscrowFactory} from "src/EscrowFactory.sol";

contract EscrowFactoryHarness is EscrowFactory {
    function exposed_computeNextAddress(
        bytes memory byteCode,
        address deployer,
        bytes32 salt,
        address buyer,
        address seller,
        address arbiter,
        IERC20 token,
        uint256 value
    ) external pure returns (address) {
        return _computeNextAddress(byteCode, deployer, salt, buyer, seller, arbiter, token, value);
    }
}
