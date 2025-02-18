// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";

contract Isolated is Script {
    Counter public counter;

    function setUp() public {
    }

    function run() public {
        address sender = makeAddr("sender");
        vm.setNonce(sender, 0);
        vm.deal(sender, 11177240900000);
        vm.prank(sender, sender);

        counter = new Counter();
        counter.increment();
    }
}

contract WithFork is Script {
    Counter public counter;

    function setUp() public {
        // specific block number has the right balance
        vm.createSelectFork("https://mainnet.era.zksync.io", 55158940);
    }

    function run() public {
        address sender = address(0x076d6da60aAAC6c97A8a0fE8057f9564203Ee545);
        vm.prank(sender, sender);

        counter = new Counter();
        counter.increment();
    }
}
