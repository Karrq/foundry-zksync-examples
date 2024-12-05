pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {GaslessVoting} from "../src/GaslessVoting.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console} from "forge-std/console.sol";

contract DeployGaslessVoting is Script {
    using stdJson for string;

    function run() public {
        // Read and parse JSON file using FFI
        string[] memory ffiCmd = new string[](2);
        ffiCmd[0] = "cat";
        ffiCmd[1] = "data/candidates.json";
        
        string memory json = string(vm.ffi(ffiCmd));

        console.log(json);
        
        // Parse the JSON using vm.parseJson instead
        string[] memory candidates = abi.decode(
            vm.parseJson(json, ".candidates"),
            (string[])
        );

        // Start broadcasting
        vm.startBroadcast();
        
        // Deploy with candidates from JSON
        GaslessVoting voting = new GaslessVoting(candidates);
        
        vm.stopBroadcast();
    }
}

