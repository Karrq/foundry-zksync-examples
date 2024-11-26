// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "zksync-contracts/zksync-contracts/l2/system-contracts/libraries/SystemContractsCaller.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../src/Factory.sol";

// To run this script:
// forge script --zksync --private-key {PRIVATE_KEY} --rpc-url {RPC_URL} script/DeployGreeterWithBytecodeHash.s.sol --broadcast --via-ir --system-mode true
contract DeployGreeterWithBytecodeHash is Script {
    function run() external {
        // Read artifact file and get the bytecode hash
        string memory artifact = vm.readFile("zkout/Greeter.sol/Greeter.json");
        bytes32 counterBytecodeHash = vm.parseJsonBytes32(artifact, ".hash");
        bytes32 salt = "JUAN";

        vm.startBroadcast();
        // Create a factory with the bytecode hash of the counter contract
        Factory factory = new Factory(counterBytecodeHash);
        // Mark as a factory dependency the counter contract
        (bool _success,) = address(vm).call(abi.encodeWithSignature("zkUseFactoryDep(string)", "Greeter"));
        require(_success, "Cheatcode failed");
        // Deploy the counter contract using the factory
        address greeter = factory.deployAccount(salt);
        require(greeter != address(0), "Greeter deployment failed");
        vm.stopBroadcast();
    }
}
