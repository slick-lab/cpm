#!/bin/bash

#assuming we alredady have sudo

set -e

echo "Installing cpm..."

REPO="https://github.com/slick-lab/cpm.git"
INSTALL_DIR="/usr/local/bin"

if ! command -v crystal &> /dev/null;
then
  echo "crystal not found"
  exit 1
fi

TMP_DIR=$(mktemp -d)
git clone --depth 1 "$REPO" "$TMP_DIR"
cd "$TMP_DIR"

crystal build src/cpm.cr --release --no-debug -o cpm

chmod +x cpm
sudo cp cpm "$INSTALL_DIR"
cd ..

rm -rf "$TMP_DIR"

echo "cpm installed"
echo "Run 'cpm init --cache' to get started

