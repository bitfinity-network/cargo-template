#!/usr/bin/env sh
# Init DFX canisters inside DFX environment
set -e
export RUST_BACKTRACE=full

WALLET=$(dfx identity get-wallet)
NETWORK="local"

deploy_canisters()
{
    export RUST_BACKTRACE=full
    local ledger_id=$(dfx canister id ledger-test)

    dfx deploy hello
}

deploy_canisters

dfx canister info hello