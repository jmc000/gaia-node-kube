#!/bin/bash -i
source config.sh

##### CONFIGURATION ###
export NODE_HOME=/root/.gaia
export CHAIN_ID=theta-testnet-001
export NODE_MONIKER=jmc
export BINARY=gaiad

##### OPTIONAL STATE SYNC CONFIGURATION ###

export STATE_SYNC=true # if you set this to true, please have TRUST HEIGHT and TRUST HASH and RPC configured
export TRUST_HEIGHT=$trust_height
export TRUST_HASH=$trust_hash
export SYNC_RPC="rpc.sentry-01.theta-testnet.polypore.xyz:26657,rpc.sentry-02.theta-testnet.polypore.xyz:26657"

echo "***********************"
echo "INSTALLED GAIAD VERSION"
gaiad version
echo "***********************"

echo "configuring chain..."
$BINARY config chain-id $CHAIN_ID --home $NODE_HOME
$BINARY config keyring-backend test --home $NODE_HOME
$BINARY config broadcast-mode block --home $NODE_HOME
$BINARY init $NODE_MONIKER --home $NODE_HOME --chain-id=$CHAIN_ID

sed -i 's/minimum-gas-prices = ""/minimum-gas-prices = "0.001uatom"/' $NODE_HOME/config/app.toml
sed -i 's/persistent_peers = ""/persistent_peers = "4529d6cbc6e4a9cecadfbf9b6f86d0584199218e@46.101.135.137:26656,639d50339d7045436c756a042906b9a69970913f@seed-01.theta-testnet.polypore.xyz:26656,3e506472683ceb7ed75c1578d092c79785c27857@seed-02.theta-testnet.polypore.xyz:26656"/' $NODE_HOME/config/config.toml
sed -i 's/laddr = ""/laddr = "tcp://gaia-full-node-svc.gaia:26657"/' $NODE_HOME/config/config.toml

if $STATE_SYNC; then
    echo "enabling state sync..."
    sed -i 's/enable = false/enable = true/' $NODE_HOME/config/config.toml
    sed -i "s/trust_height = 0/trust_height = $TRUST_HEIGHT/" $NODE_HOME/config/config.toml
    sed -i -e "/trust_hash =/ s/= .*/= \"$TRUST_HASH\"/" $NODE_HOME/config/config.toml
    sed -i -e "/rpc_servers =/ s/= .*/= \"$SYNC_RPC\"/" $NODE_HOME/config/config.toml
else
    echo "disabling state sync..."
fi

##### IMPORTING PRIV KEY ###

echo "***********************"
echo "importing private key..."
echo $password | gaiad keys import jmc /keys/pkey # CHANGE THAT

##### STARTING SERVICE DEAMON ###

echo "***********************"
echo "starting the daemon..."
$BINARY start --x-crisis-skip-assert-invariants
echo "***********************"
