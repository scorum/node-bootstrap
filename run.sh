#!/bin/bash

dir=$(pwd)
name="${dir##*/}"

wget "https://raw.githubusercontent.com/scorum/node-bootstrap/master/witness.config.ini" -O config.ini

mkdir blockchain
cd blockchain

echo "download blocklog"
wget "https://sandboxscorum.blob.core.windows.net/blockchain/mainnet-witness_scorum/release:0.4.0.e826520_block-log_2018-11-12T23_10_22.316114.zip" -O blocklog.zip

echo "download state"
wget "https://sandboxscorum.blob.core.windows.net/blockchain/mainnet-witness_scorum/release:0.4.0.e826520_shared-mem_2018-11-12T23_10_22.316114.zip" -O state.zip

echo "unziping"
unzip blocklog.zip
unzip state.zip

rm shared_memory.meta

cd ..

echo "container name: ${name}"

docker run \
    -v "${dir}":/var/lib/scorumd \
    -d -p 2001:2001 -p 8090:8090 --name "${name}" \
    "scorum/release:0.4.0.460fa68"

