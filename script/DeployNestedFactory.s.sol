// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/NestedFactory.sol";

// To run this script:
// forge script --zksync --private-key {PRIVATE_KEY} --rpc-url {RPC_URL} script/DeployNestedFactory.s.sol --broadcast

// foundry_zksync_compiler::zksolc: new factory dependency name="NestedFactory" deps=2
// foundry_zksync_compiler::zksolc: new factory dependency name="ClassicFactory" deps=2
// foundry_zksync_compiler::zksolc: new factory dependency name="Item" deps=1
contract DeployNestedFactory is Script {
    function run() public {
        vm.startBroadcast();
        NestedFactory factory = new NestedFactory();
        factory.create(42);
        assert(factory.getNumber() == 42);
        vm.stopBroadcast();
    }
}
