#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

EXPECTED="$1"
GOT=$(hledger --version)
if [ "$EXPECTED" != "$GOT" ]; then
	echo "Expected '$EXPECTED', got '$GOT'"
	exit 1
else
	echo "$GOT is installed"
fi
