// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TestExt} from "forge-zksync-std/TestExt.sol";

import "../src/Counter.sol";
import "../src/LargeContracts.sol";

interface VmExt2 {
    function zkGetTransactionNonce(
        address account
    ) external view returns (uint64 nonce);
    function zkGetDeploymentNonce(
        address account
    ) external view returns (uint64 nonce);
}

contract Default is Test, TestExt {
    VmExt2 internal constant vmExt2 = VmExt2(VM_ADDRESS);

    function assertTxNonce(address target, uint256 value) view internal {
       assertEq(value, vmExt2.zkGetTransactionNonce(target), "transaction nonce");
    }

    function assertDeployNonce(address target, uint256 value) view internal {
       assertEq(value, vmExt2.zkGetDeploymentNonce(target), "deployment nonce");
    }

    address sender;
    function setUp() external {
       sender = makeAddr("alice");
       vm.deal(sender, 1 ether);
    }

    function testWithSlimFDeps() external {
        uint256 txNonce = vmExt2.zkGetTransactionNonce(sender);
        uint256 deploymentNonce = vmExt2.zkGetDeploymentNonce(sender);

        vm.broadcast(sender); // otherwise nonce is not propagated
        new Counter();
        assertDeployNonce(sender, deploymentNonce + 1);
        assertTxNonce(sender, txNonce + 1);
    }

    function testWithFatFDeps() external {
        uint256 txNonce = vmExt2.zkGetTransactionNonce(sender);
        uint256 deploymentNonce = vmExt2.zkGetDeploymentNonce(sender);

        vmExt.zkUseFactoryDep("LargeContractA"); // otherwise we don't batch anything
        vm.broadcast(sender); // otherwise nonce is not propagated
        new Counter();
        assertDeployNonce(sender, deploymentNonce + 1);
        assertTxNonce(sender, txNonce + 2);
    }
}
