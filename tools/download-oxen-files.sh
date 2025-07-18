#!/bin/bash

if [ "$#" -ne 1 ] || [[ "$1" != http* ]]; then
    cat <<EOF >&2
Usage: $0 URL -- download and extract an antd-core build (typically from https://antd.rocks)
Some common URLs:
    https://antd.rocks/antd-io/antd-core/antd-stable-linux-LATEST.tar.xz
    https://antd.rocks/antd-io/antd-core/antd-stable-win-LATEST.zip
    https://antd.rocks/antd-io/antd-core/antd-stable-macos-LATEST.tar.xz
    https://antd.rocks/antd-io/antd-core/antd-dev-linux-LATEST.tar.xz
    https://antd.rocks/antd-io/antd-core/antd-dev-win-LATEST.zip
    https://antd.rocks/antd-io/antd-core/antd-dev-macos-LATEST.tar.xz
EOF
    exit 1
fi

if ! [ -f tools/download-oxen-files.sh ] || ! [ -d bin ]; then
    echo "This script needs to be invoked from the antd-electron-gui-wallet top-level project directory" >&2
    exit 1
fi

tar=tar
if [[ "$($tar --version)" == bsdtar* ]]; then
    tar=gtar
    if ! command -v $tar; then
        echo "GNU tar is required, but your tar is \`bsdtar' and \`gtar' doesn't work." >&2
        echo "This is probably a mac; please install gnutar (e.g. via macports or homebrew)" >&2
        exit 1
    fi
fi

rm -f bin/oxen*

if [[ "$1" = *win*.zip ]]; then
    tmpzip=$(mktemp XXXXXXXXXXXX.zip)
    curl -sSo $tmpzip "$1"
    unzip -p $tmpzip '*/antdd.exe' >bin/antdd.exe
    unzip -p $tmpzip '*/antd-wallet-rpc.exe' >bin/antd-wallet-rpc.exe
    rm -f $tmpzip

    echo "Extracted:"
    ls -l bin/*.exe
else
    curl -sS "$1" | $tar --strip-components=1 -C bin -xJv --no-anchored antdd antd-wallet-rpc

    echo "Checking downloaded versions:"
    echo -n "antdd: "; ./bin/antdd --version
    echo -n "antd-wallet-rpc: "; ./bin/antd-wallet-rpc --version
fi
