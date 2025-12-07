#!/usr/bin/env bash
set -e

REPO=https://github.com/nilszeilon/
PROJECT=armarchy
BUILD=$HOME/.local/share

mkdir -p "$BUILD"
pushd "$BUILD"
rm -rf "$PROJECT"
git clone $REPO/$PROJECT

pushd "$PROJECT"
git checkout add-aarch64-support
sed -i '/source .*guard\.sh/s/^/#/' install/preflight/all.sh
bash install.sh
popd
rm -rf omarchy
popd
