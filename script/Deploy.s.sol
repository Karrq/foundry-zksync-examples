// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "zksync-contracts/zksync-contracts/l2/system-contracts/libraries/SystemContractsCaller.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../src/Factory.sol";
import "forge-std/console.sol";
import "forge-zksync-std/TestExt.sol";

contract DeployCounterWithBytecodeHash is Script, TestExt {
    function run() external {
        // Read artifact file and get the bytecode hash
        string memory artifact = vm.readFile("zkout/Counter.sol/Counter.json");
        bytes32 counterBytecodeHash = vm.parseJsonBytes32(artifact, ".hash");
        bytes32 salt = "ASDASDASKDasdsAS";

        vm.startBroadcast();
        Factory factory = new Factory(counterBytecodeHash);
        console.log("Factory deployed");
        console.logBytes32(counterBytecodeHash);

        vmExt.zkUseFactoryDep("Counter");
        address counter = factory.deployContract(salt, abi.encode());
        require(counter != address(0), "Counter deployment failed");
        vm.stopBroadcast();
    }
}