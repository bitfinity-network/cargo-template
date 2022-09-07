#!/usr/bin/env sh

cargo build --target wasm32-unknown-unknown --release
ic-cdk-optimizer target/wasm32-unknown-unknown/release/hello_ic.wasm -o .artifact/hello_ic.wasm
cp ./src/hello_ic/hello_ic.did .artifact/