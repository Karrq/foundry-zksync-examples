// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {GaslessVoting} from "../src/GaslessVoting.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {console} from "forge-std/console.sol";

contract GaslessVotingTest is Test {
    using stdJson for string;

    GaslessVoting public voting;
    address public owner;
    address public voter1;
    address public voter2;

    function setUp() public {
        // Read candidates from JSON using FFI
        string[] memory ffiCmd = new string[](2);
        ffiCmd[0] = "cat";
        ffiCmd[1] = "data/candidates.json";
        
        string memory json = string(vm.ffi(ffiCmd));
        string[] memory candidates = abi.decode(
            json.parseRaw(".candidates"),
            (string[])
        );

        owner = address(this);
        voter1 = makeAddr("voter1");
        voter2 = makeAddr("voter2");
        
        // Deploy contract with candidates from JSON
        voting = new GaslessVoting(candidates);
    }

    function test_InitialState() public {
        (string[] memory candidates, uint256[] memory voteCounts) = voting.getAllCandidates();
        
        // Test initial candidates
        assertEq(candidates.length, 6); // We have 6 candidates in our JSON
        assertEq(candidates[0], "Alice");
        assertEq(candidates[1], "Bob");
        assertEq(candidates[2], "Charlie");
        
        // Test initial vote counts are zero
        for(uint i = 0; i < voteCounts.length; i++) {
            assertEq(voteCounts[i], 0);
        }
    }

    function test_Voting() public {
        // Test single vote
        vm.prank(voter1);
        voting.vote(0); // Vote for Alice
        
        (string memory name, uint256 voteCount) = voting.getCandidate(0);
        assertEq(name, "Alice");
        assertEq(voteCount, 1);
    }

    function test_MultipleVotes() public {
        // Multiple voters voting for the same candidate
        vm.prank(voter1);
        voting.vote(0); // Vote for Alice
        
        vm.prank(voter2);
        voting.vote(0); // Vote for Alice again
        
        (, uint256 voteCount) = voting.getCandidate(0);
        assertEq(voteCount, 2);
    }

    function test_AddCandidate() public {
        string memory newCandidate = "Grace";
        voting.addCandidate(newCandidate);
        
        (string[] memory candidates,) = voting.getAllCandidates();
        assertEq(candidates[candidates.length - 1], newCandidate);
    }

    function testFail_AddCandidateNotOwner() public {
        vm.prank(voter1);
        voting.addCandidate("Grace"); // Should fail as voter1 is not the owner
    }

    function test_MostVotes() public {
        // Setup multiple votes
        vm.prank(voter1);
        voting.vote(1); // Vote for Bob
        
        vm.prank(voter2);
        voting.vote(1); // Vote for Bob again
        
        vm.prank(address(0xdead));
        voting.vote(0); // Vote for Alice
        
        string memory winner = voting.mostVotes();
        assertEq(winner, "Bob");
    }

    function testFail_InvalidCandidate() public {
        voting.vote(999); // Should fail with invalid candidate ID
    }

    function test_GetAllCandidates() public {
        (string[] memory candidates, uint256[] memory voteCounts) = voting.getAllCandidates();
        
        assertEq(candidates.length, voteCounts.length);
        
        // Test some votes
        vm.prank(voter1);
        voting.vote(0);
        
        (,uint256[] memory newVoteCounts) = voting.getAllCandidates();
        assertEq(newVoteCounts[0], 1);
    }
} 