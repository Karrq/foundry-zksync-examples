// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract GaslessVoting {
    address public owner;
    string[] public candidates;
    mapping(uint256 => uint256) public votes;

    event VoteCasted(address indexed voter, uint256 candidateId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor(string[] memory _candidates) {
        owner = msg.sender;
        candidates = _candidates;
    }

    function getAllCandidates() external view returns (string[] memory, uint256[] memory) {
    uint256[] memory allVotes = new uint256[](candidates.length);
    for (uint256 i = 0; i < candidates.length; i++) {
        allVotes[i] = votes[i];
    }
        return (candidates, allVotes);
    }

    function vote(uint256 candidateId) external {
        require(candidateId < candidates.length, "Invalid candidate");

        votes[candidateId]++;

        emit VoteCasted(msg.sender, candidateId);
    }

    function getCandidate(uint256 candidateId) external view returns (string memory name, uint256 voteCount) {
        require(candidateId < candidates.length, "Invalid candidate");
        return (candidates[candidateId], votes[candidateId]);
    }

    function addCandidate(string memory candidateName) external onlyOwner {
        candidates.push(candidateName);
    }

    function mostVotes() external view returns (string memory name) {
        //return the name of the candidate with the most votes
        uint256 maxVotes = 0;
        for (uint256 i = 0; i < candidates.length; i++) {
            if (votes[i] > maxVotes) {
                maxVotes = votes[i];
                name = candidates[i];
            }
        }
        return name;
    }
}
