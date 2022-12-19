#!/usr/bin/env sh

set -euo pipefail

function error() {
    local message="$1"
    echo "error: $message"
    exit 1
}

function info() {
    echo "$@"
}

PWD="$(dirname $(readlink -f -- $0))"
DIST="$PWD/dist"
VERSION="1.28"

while [[ $# -gt 0 ]]; do
	case "$1" in
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

case "$(uname -s)" in
Darwin)
    case "$VERSION" in
    1.27|1.27.1|1.28)
        TMP_DIR=$(mktemp -d -t ci-XXXXXXXXXX)
        pushd "$TMP_DIR"
        download "https://github.com/simonmichael/hledger/releases/download/$VERSION/hledger-mac-x64.zip" 
        unzip -o "hledger-mac-x64.zip"
        mkdir -p "$DIST"
        tar xvf "hledger-mac-x64.tar" --directory "$DIST"
        popd
        rm -rf $TMP_DIR
        ;;
    1.26|1.26.1)
        TMP_DIR=$(mktemp -d -t ci-XXXXXXXXXX)
        pushd "$TMP_DIR"
        download "https://github.com/simonmichael/hledger/releases/download/$VERSION/hledger-mac-x64.zip" 
        mkdir -p "$DIST"
        unzip -o "hledger-mac-x64.zip" -d "$DIST"
        chmod +x "$DIST/hledger" "$DIST/hledger-web" "$DIST/hledger-ui"
        popd
        rm -rf $TMP_DIR
        ;;
    1.20.1)
        TMP_DIR=$(mktemp -d -t ci-XXXXXXXXXX)
        pushd "$TMP_DIR"
        download "https://github.com/simonmichael/hledger/releases/download/hledger-1.20.1/hledger-macos.zip"
        mkdir -p "$DIST"
        unzip -o "hledger-macos.zip" -d "$DIST"
        chmod +x "$DIST/hledger" "$DIST/hledger-web" "$DIST/hledger-ui"
        popd
        rm -rf $TMP_DIR
        ;;
    1.18.1|1.19|1.19.1|1.20|1.20.2|1.20.3|1.20.4|1.21|1.22|1.22.1|1.22.2|1.23|1.24|1.24.1|1.24.99.1|1.24.99.2|1.25)
        TMP_DIR=$(mktemp -d -t ci-XXXXXXXXXX)
        pushd "$TMP_DIR"
        download "https://github.com/simonmichael/hledger/releases/download/$VERSION/hledger-macos.zip" 
        mkdir -p "$DIST"
        unzip -o "hledger-macos.zip" -d "$DIST"
        chmod +x "$DIST/hledger" "$DIST/hledger-web" "$DIST/hledger-ui"
        popd
        rm -rf $TMP_DIR
        ;;
    1.18)
        TMP_DIR=$(mktemp -d -t ci-XXXXXXXXXX)
        pushd "$TMP_DIR"
        download "https://github.com/simonmichael/hledger/releases/download/$VERSION/hledger-macos-unoptimised.zip" 
        mkdir -p "$DIST"
        unzip -o "hledger-macos-unoptimised.zip" -d "$DIST"
        chmod +x "$DIST/hledger" "$DIST/hledger-web" "$DIST/hledger-ui"
        popd
        rm -rf $TMP_DIR
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
