#!/usr/bin/env sh
# 
# Run tests locally against dockerized DFX environment.
# Require only docker to be installed
#
# Will try to reuse local cache for cargo and target dir.
# This is why tests will run with current user id not a docker user.

#
# ENV variables for customization
#

# Module name that produces wasm
IC_MODULE_NAME="hello_ic"

# Docker image to run tests
# If github packages downloads are slow, try GCP registry:
# us-central1-docker.pkg.dev/dfx-server/ci/ic-dev-full:latest
CI_IMAGE=${CI_IMAGE:-"ghcr.io/infinity-swap/ic-dev-full:latest"}

# For non empty value will clean before building wasm.
# In a case if you are lazy and can not do it from CLI
CARGO_CLEAN=""


#
# Now script execution begins
#

# Assuming that all scripts are in a ./dev directory
SCRIPT_DIR=$(realpath $(dirname "$0"))
SCRIPT_DIR_NAME=$(basename $SCRIPT_DIR)
cd $SCRIPT_DIR/..
PROJECT_DIR=$(realpath "${SCRIPT_DIR}/..")

LOCAL_CARGO_HOME=$(realpath ${CARGO_HOME:-~/.cargo})

DOCKER_HOME_DIR="/workspace"
DOCKER_PROJECT_DIR="/workspace/project"


docker pull $CI_IMAGE

docker run --rm -ti \
-u $(id -u ${USER}):$(id -g ${USER}) \
-e IC_MODULE_NAME=$IC_MODULE_NAME \
-e CARGO_HOME=$DOCKER_HOME_DIR/.cargo \
-v $LOCAL_CARGO_HOME:$DOCKER_HOME_DIR/.cargo \
-v $PROJECT_DIR:$DOCKER_PROJECT_DIR \
$CI_IMAGE \
$DOCKER_PROJECT_DIR/$SCRIPT_DIR_NAME/dfx.run.tests.sh

