#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test

BIN="hello-world-fn"
TARGET="aarch64-unknown-linux-gnu"

LAMBDA_DIR=target/lambda
RELEASE_DIR=target/$TARGET/release
FN_DIR=$LAMBDA_DIR/$BIN

mkdir -p $LAMBDA_DIR
cargo zigbuild --bin $BIN --release --target $TARGET
rm -rf $FN_DIR 2>/dev/null || true
mkdir -p $FN_DIR
cp $RELEASE_DIR/$BIN $FN_DIR/bootstrap

cd $FN_DIR
zip -j bootstrap.zip bootstrap
rm bootstrap

cd "../../.."

terraform apply -auto-approve
