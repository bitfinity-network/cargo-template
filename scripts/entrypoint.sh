#!/bin/bash
set -m
export RUST_BACKTRACE=full

http-server --cors -p 8001 .dfx/local &

dfx start --host $IC_HOST
