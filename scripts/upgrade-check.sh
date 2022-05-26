#!/usr/bin/env sh
# This script meant to be run inside latest development environment published by previous builds
# set -e
export RUST_BACKTRACE=full

ARTIFACT_DIR="$(realpath $1)"

upgrade_single_canister() {
    local name="$1"
    local canister_before=$(dfx canister info $name)

    echo "Starting upgrade for: $name"
    echo $canister_before

    dfx canister install -m upgrade "$name"
    result=$?

    local canister_after=$(dfx canister info $name)

    if [ $result -ne 0 ]; then
        echo "!!! UPGRADE FAILED !!!"
    else
        echo "!!! UPGRADE COMPLETE !!!"
    fi
    
    echo "FROM"
    echo "$canister_before"
    echo "TO:"
    echo "$canister_after"

    if [ $result -ne 0 ]; then exit 42; fi
    # return $result
}

cd $HOME

# Prepare dfx config
J=$(jq ".canisters += {\"hello\":{\"type\":\"custom\",\"wasm\":\"$ARTIFACT_DIR/hello_ic.wasm\",\"candid\":\"$ARTIFACT_DIR/hello_ic.did\"}}" ./dfx.json) && echo "$J" > ./dfx.json

dfx start --background
# Need more time to initialize all 
sleep 10

# Here we could have multiple calls to different canisters
upgrade_single_canister hello

# Optional step
dfx stop
