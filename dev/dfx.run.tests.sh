#!/usr/bin/env sh
# 
# Run tests against DFX environment
# Could be launched inside docker ore locally

if ! (which dfx) ; then
    echo -e "\nCould not locate dfx command!\n"
    exit 1
fi

if ! (which ic-nns-init) ; then
    echo -e "\nCould not locate ic-nns-init command!\n"
    exit 1
fi

if [ -z "$IC_MODULE_NAME" ]; then 
    echo "Provide env var IC_MODULE_NAME"
    exit 1
fi

if [ -z "$DFX_WASMS_DIR" ]; then
    echo "Provide env var DFX_WASMS_DIR - path to a directory containing all required *.wasm files"
    exit 1
fi

if [ -z "$DFX_DEV_IDENTITY" ]; then
    DFX_DEV_IDENTITY="default"
fi

IC_URI=${IC_URI:-"http://localhost:8000"}

#
# Now script execution begins
#

# Adjusting paths
# Assuming that script is in ./dev folder
SCRIPT_DIR=$(realpath $(dirname "$0"))
cd $SCRIPT_DIR/..
PROJECT_DIR=$(realpath ${PROJECT_DIR:-"$SCRIPT_DIR/.."})

CARGO_TARGET_DIR=${CARGO_TARGET_DIR:-"target"}
PROJECT_TARGET_DIR="$PROJECT_DIR/${CARGO_TARGET_DIR}"

# Building module
cd $PROJECT_DIR
export RUST_BACKTRACE=full

# Clean targets before build
if [ ! -z "$CARGO_CLEAN" ]; then 
    cargo clean
fi

cargo build --target wasm32-unknown-unknown --release -p $IC_MODULE_NAME
if [ $? -ne 0 ]; then  echo "ERROR!"; exit 1; fi

# Move compiled wasm to DFX_WASMS_DIR
mv $PROJECT_TARGET_DIR/wasm32-unknown-unknown/release/$IC_MODULE_NAME.wasm $DFX_WASMS_DIR
if [ $? -ne 0 ]; then  echo "ERROR!"; exit 1; fi

echo -e "\n--- Available WASM modules ---\n"
ls -la $DFX_WASMS_DIR

# Starding DFX
dfx start --clean --background
if [ $? -ne 0 ]; then echo "ERROR! Could not start DFX"; exit 1; fi

echo -e "\n!!! Will use \"$DFX_DEV_IDENTITY\" as minter identity !!!\n"
dfx identity use $DFX_DEV_IDENTITY
principal=$(dfx identity get-principal)
minter=$(dfx ledger account-id)

echo "Deploying NNS"
echo -e "\nMINTER: $minter\nPRINCIPAL: $principal\n"

# Limit execution time for this script
# It could go into infinite retry loop on deployment error
timeout 180 \
ic-nns-init --url $IC_URI \
--wasm-dir $DFX_WASMS_DIR \
--initial-neurons $SCRIPT_DIR/initial-neurons.csv \
--minter $minter \
--initialize-ledger-with-test-accounts-for-principals $principal

if [ $? -ne 0 ]; then echo "ERROR! NNS deploy failed!"; exit 1; fi

cargo test
TEST_RESULT=$?

# This is mosly for local run
dfx stop
sleep 3

echo "Tests exit code: $TEST_RESULT"
exit $TEST_RESULT
