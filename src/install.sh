#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

PWD="$(dirname $(readlink -f -- $0))"
DIST="$PWD/dist"
VERSION="1.32"
OS="$(uname -s)"

function help() {
	echo "Usage: $0 <flags>"
	echo
	echo "flags:"
	echo "  --version  hledger version to install.       (default: $VERSION)"
	echo "  --dist     directory to install binaries to. (default: $DIST)"
	echo "  --os       os name to install binaries for.  (default: $OS)"
	echo "  --help     display this message."
}

function error() {
	echo "error: $@"
	echo
	help
	exit 1
}

function info() {
	echo "$@"
}

while [[ $# -gt 0 ]]; do
	case "$1" in
	--help)
		help
		exit 1
		;;
	--version)
		VERSION="$2"
		shift
		shift
		;;
	--dist)
		DIST="$2"
		shift
		shift
		;;
	--os)
		OS="$2"
		shift
		shift
		;;
	*)
		error "unknown flag $1"
		;;
	esac
done

info "version: $VERSION"
info "dist: $DIST"

function download() {
	info "downloading $@"
	local http_code=$(curl --silent --remote-name --location --write-out "%{http_code}" "$@")
	if [[ ${http_code} -ne 200 ]]; then
		error "GET $@: $http_code"
	fi
}

function cleanup() {
	popd
	rm -rf "$TMP_DIR"
}

TMP_DIR=$(mktemp -d -t ci-XXXXXXXXXX)
pushd "$TMP_DIR"
trap cleanup EXIT

case "$OS" in
Linux)
	case "$VERSION" in
	1.27 | 1.27.1 | 1.28 | 1.29 | 1.29.1 | 1.29.2 | 1.30 | 1.31 | 1.32)
		download "https://github.com/simonmichael/hledger/releases/download/$VERSION/hledger-linux-x64.zip"
		unzip -o "hledger-linux-x64.zip"
		mkdir -p "$DIST"
		tar xvf "hledger-linux-x64.tar" --directory "$DIST"
		;;
	1.24.1 | 1.24.99.1 | 1.24.99.2 | 1.25 | 1.26 | 1.26.1)
		download "https://github.com/simonmichael/hledger/releases/download/$VERSION/hledger-linux-x64.zip"
		mkdir -p "$DIST"
		unzip -o "hledger-linux-x64.zip" -d "$DIST"
		mv "$DIST/hledger-linux-x64" "$DIST/hledger"
		mv "$DIST/hledger-web-linux-x64" "$DIST/hledger-web"
		mv "$DIST/hledger-ui-linux-x64" "$DIST/hledger-ui"
		chmod +x "$DIST/hledger" "$DIST/hledger-web" "$DIST/hledger-ui"
		;;
	1.22.2 | 1.23 | 1.24)
		download "https://github.com/simonmichael/hledger/releases/download/$VERSION/hledger-linux-static-x64.zip"
		mkdir -p "$DIST"
		unzip -o "hledger-linux-static-x64.zip" -d "$DIST"
		mv "$DIST/hledger-linux-static-x64" "$DIST/hledger"
		mv "$DIST/hledger-web-linux-static-x64" "$DIST/hledger-web"
		mv "$DIST/hledger-ui-linux-static-x64" "$DIST/hledger-ui"
		chmod +x "$DIST/hledger" "$DIST/hledger-web" "$DIST/hledger-ui"
		;;
	1.22 | 1.22.1)
		download "https://github.com/simonmichael/hledger/releases/download/$VERSION/hledger-linux-static-x64.zip"
		mkdir -p "$DIST"
		unzip -o "hledger-linux-static-x64.zip" -d "$DIST"
		mv "$DIST/hledger-static-linux-x64" "$DIST/hledger"
		mv "$DIST/hledger-web-static-linux-x64" "$DIST/hledger-web"
		mv "$DIST/hledger-ui-static-linux-x64" "$DIST/hledger-ui"
		chmod +x "$DIST/hledger" "$DIST/hledger-web" "$DIST/hledger-ui"
		;;
	1.21)
		download "https://github.com/simonmichael/hledger/releases/download/$VERSION/hledger-ubuntu.zip"
		mkdir -p "$DIST"
		unzip -o "hledger-ubuntu.zip" -d "$DIST"
		chmod +x "$DIST/hledger" "$DIST/hledger-web" "$DIST/hledger-ui"
		;;
	1.20.1)
		sudo apt install libncurses5
		download "https://github.com/simonmichael/hledger/releases/download/hledger-$VERSION/hledger-ubuntu.zip"
		mkdir -p "$DIST"
		unzip -o "hledger-ubuntu.zip" -d "$DIST"
		chmod +x "$DIST/hledger" "$DIST/hledger-web" "$DIST/hledger-ui"
		;;
	1.18.1 | 1.19 | 1.19.1 | 1.20 | 1.20.2 | 1.20.3 | 1.20.4)
		sudo apt install libncurses5
		download "https://github.com/simonmichael/hledger/releases/download/$VERSION/hledger-ubuntu.zip"
		mkdir -p "$DIST"
		unzip -o "hledger-ubuntu.zip" -d "$DIST"
		chmod +x "$DIST/hledger" "$DIST/hledger-web" "$DIST/hledger-ui"
		;;
	1.18)
		sudo apt install libncurses5
		download "https://github.com/simonmichael/hledger/releases/download/$VERSION/hledger-ubuntu-unoptimised.zip"
		mkdir -p "$DIST"
		unzip -o "hledger-ubuntu-unoptimised.zip" -d "$DIST"
		chmod +x "$DIST/hledger" "$DIST/hledger-web" "$DIST/hledger-ui"
		;;
	*)
		error "$VERSION unsupported"
		;;
	esac
	;;
Darwin)
	case "$VERSION" in
	1.27 | 1.27.1 | 1.28 | 1.29 | 1.29.1 | 1.29.2 | 1.30 | 1.31 | 1.32)
		download "https://github.com/simonmichael/hledger/releases/download/$VERSION/hledger-mac-x64.zip"
		unzip -o "hledger-mac-x64.zip"
		mkdir -p "$DIST"
		tar xvf "hledger-mac-x64.tar" --directory "$DIST"
		;;
	1.26 | 1.26.1)
		download "https://github.com/simonmichael/hledger/releases/download/$VERSION/hledger-mac-x64.zip"
		mkdir -p "$DIST"
		unzip -o "hledger-mac-x64.zip" -d "$DIST"
		chmod +x "$DIST/hledger" "$DIST/hledger-web" "$DIST/hledger-ui"
		;;
	1.20.1)
		download "https://github.com/simonmichael/hledger/releases/download/hledger-$VERSION/hledger-macos.zip"
		mkdir -p "$DIST"
		unzip -o "hledger-macos.zip" -d "$DIST"
		chmod +x "$DIST/hledger" "$DIST/hledger-web" "$DIST/hledger-ui"
		;;
	1.18.1 | 1.19 | 1.19.1 | 1.20 | 1.20.2 | 1.20.3 | 1.20.4 | 1.21 | 1.22 | 1.22.1 | 1.22.2 | 1.23 | 1.24 | 1.24.1 | 1.24.99.1 | 1.24.99.2 | 1.25)
		download "https://github.com/simonmichael/hledger/releases/download/$VERSION/hledger-macos.zip"
		mkdir -p "$DIST"
		unzip -o "hledger-macos.zip" -d "$DIST"
		chmod +x "$DIST/hledger" "$DIST/hledger-web" "$DIST/hledger-ui"
		;;
	1.18)
		download "https://github.com/simonmichael/hledger/releases/download/$VERSION/hledger-macos-unoptimised.zip"
		mkdir -p "$DIST"
		unzip -o "hledger-macos-unoptimised.zip" -d "$DIST"
		chmod +x "$DIST/hledger" "$DIST/hledger-web" "$DIST/hledger-ui"
		;;
	*)
		error "$VERSION unsupported"
		;;
	esac
	;;
*)
	error "$(uname -s) unsupported"
	;;
esac
