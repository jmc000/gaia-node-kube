#!/bin/bash -i
echo "======================== CREATE VALIDATOR ========================"
gaiad tx staking create-validator \
    --amount=400000uatom \
    --pubkey=$(gaiad tendermint show-validator) \
    --moniker="jmc-from-k8s" \
    --chain-id=theta-testnet-001 \
    --commission-rate="0.10" \
    --commission-max-rate="0.20" \
    --commission-max-change-rate="0.01" \
    --min-self-delegation="50000" \
    --gas-prices="0.0030uatom" \
    --from=jmc \
    --yes
