#!/bin/bash

function unzip_not_installed() {
	echo "install unzip package"
	exit 1
}

dir=$(pwd)
name="${dir##*/}"

wget "https://raw.githubusercontent.com/scorum/node-bootstrap/master/witness.config.ini" -O config.ini

mkdir blockchain
cd blockchain

echo "download blocklog"
wget "https://sandboxscorum.blob.core.windows.net/blockchain/mainnet-witness_scorum/release:0.4.1.b50567a_block-log_2018-12-05T03:47:17.873335.zip" -O blocklog.zip

echo "download state"
wget "https://sandboxscorum.blob.core.windows.net/blockchain/mainnet-witness_scorum/release:0.4.1.b50567a_shared-mem_2018-12-05T03:47:17.873335.zip" -O state.zip

echo "unziping"
unzip blocklog.zip || unzip_not_installed
unzip state.zip || unzip_not_installed

rm shared_memory.meta

cd ..

echo "container name: ${name}"

docker run \
    -v "${dir}":/var/lib/scorumd \
    -d -p 2001:2001 -p 8090:8090 --name "${name}" \
    "scorum/release:0.4.1.b50567a"

