// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

contract TestExtended is Test {
    address immutable defaultSender = vm.addr(1234);

    function expectEmit() internal {
        vm.expectEmit(true, true, true, true);
    }

    function expectRevert(string memory revertMessage) internal {
        vm.expectRevert(bytes(revertMessage));
    }

    modifier from(address newPrank) {
        vm.startPrank(newPrank);
        _;
    }
}
