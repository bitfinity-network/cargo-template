#!/bin/bash

set -m

http-server --cors -p 8001 .dfx/local &

dfx start --host $IC_HOST
