# Demo 

1. Deploy paymaster contracts
zf create ./src/GaslessPaymaster.sol:GaslessPaymaster --rpc-url ${SEPOLIA_RPC} --private-key ${PRIVATE_KEY} --zksync --value 0.05ether

1.a Verify paymaster contract
zf verify-contract 0xB6041e792eAF5b1A554BfA69EaeCC2Efd7Bf5EA0 ./src/GaslessPaymaster.sol:GaslessPaymaster --verifier zksync --verifier-url ${VERIFIER_URL} --zksync

2. Use script to deploy voting contract
zf script --zksync script/DeployGaslessVoting.sol --rpc-url ${SEPOLIA_RPC} --private-key ${PRIVATE_KEY} --via-ir --broadcast

3. Cast a vote using paymaster
zc send ${VOTING_CONTRACT_ADDRESS} "vote(uint256)" 1 --rpc-url ${SEPOLIA_RPC} --private-key ${PRIVATE_KEY} --zk-paymaster-address ${PAYMASTER_ADDRESS} --zk-paymaster-input $(cast calldata "general(bytes)" "0x")

