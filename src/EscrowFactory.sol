// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

import {IEscrow} from "./interfaces/IEscrow.sol";
import {IEscrowFactory} from "./interfaces/IEscrowFactory.sol";
import {Escrow} from "./Escrow.sol";

contract EscrowFactory is IEscrowFactory {
    using SafeERC20 for IERC20;

    function createEscrow(address seller, address arbiter, IERC20 token, uint256 value, bytes32 salt)
        external
        returns (IEscrow)
    {
        require(value > 0, "Value cannot be zero");

        address nextEscrowAddress = _computeNextAddress(
            type(Escrow).creationCode, address(this), salt, msg.sender, seller, arbiter, token, value
        );
        token.safeTransferFrom(msg.sender, nextEscrowAddress, value);

        Escrow escrow = new Escrow{salt: salt}(msg.sender, seller, arbiter, token, value);
        require(address(escrow) == nextEscrowAddress, "Invalid deployment address");

        emit EscrowCreated(address(escrow), msg.sender, seller, arbiter, token, value);

        return escrow;
    }

    function _computeNextAddress(
        bytes memory byteCode,
        address deployer,
        bytes32 salt,
        address buyer,
        address seller,
        address arbiter,
        IERC20 token,
        uint256 value
    ) internal pure returns (address) {
        return address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            deployer,
                            salt,
                            keccak256(abi.encodePacked(byteCode, abi.encode(buyer, seller, arbiter, token, value)))
                        )
                    )
                )
            )
        );
    }
}
