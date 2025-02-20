export RUST_LOG := "debug,hyper=off,reqwest=off,mio=off,alloy_rpc_client=off,alloy_transport_http=off,foundry_zksync_core=trace,foundry_zksync_core::vm::storage_view=off"
export ZK_DEBUG_RESOLVE_HASHES := "true"
export ZK_DEBUG_HISTORICAL_BLOCK_HASHES := "1"

foundry-zksync := "../../foundry-zksync"
branch := "main"
foundry_project := justfile_directory()

sk-sepolia := '--private-key "0x77b0287249f5c92f66814e9cf6f88fe6d6df6d9a878f5bba78a5074883fb4373"'
sk-era := '--private-key "0x3d3cbc973389cb26f657686445bcc75662b415b656078503592ac8c1abb8810e"'

rpc-era := '--rpc-url "http://localhost:8011"'
rpc-sepolia := '--rpc-url "https://sepolia.era.zksync.dev"'
rpc-mainnet := '--rpc-url "https://mainnet.era.zksync.io"'

era *args:
  killall anvil-zksync || true
  RUST_LOG=info nix run ~/personal/my-nix#anvil-zksync -- {{args}} &

alias d := do
alias dc := do-cast
do *args:
  just -f {{foundry-zksync}}/{{branch}}/Justfile do {{foundry_project}} {{args}}
do-cast *args:
  just -f {{foundry-zksync}}/{{branch}}/Justfile do-cast {{foundry_project}} {{args}}

alias b := build
build *args: (do "build" args)

alias t := test
test *args: (do "test --zksync" args)

alias s := script
alias se := script-era
alias st := script-sepolia
script *args: (do "script --zksync" args)
script-era *args: (era "run") (do "script --zksync" sk-era rpc-era args)
script-sepolia *args: (do "script --zksync" sk-sepolia rpc-sepolia args)

alias c := clean
clean: (do "clean")
  rm -rf zkout

verify-sepolia addr contract *args: (do "verify-contract" addr contract "--chain 300" "--watch" args)

factory-deps contract:
  jq .factoryDependencies ./zkout/{{contract}}.sol/{{contract}}.json

search-artifact term transform=".":
  @fd . --extension ".json" -t file './zkout' \
    -x jq --arg file {} '{hash: .hash, deps: .factoryDependencies, filename: $file}' {} \
     | jq 'select((.filename | contains("{{term}}")) or (.hash // "" | contains("{{term}}")) or (.deps // {} | keys | .[] | contains("{{term}}"))) | {{transform}}'
