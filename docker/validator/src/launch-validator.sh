#!/bin/bash -i
gaiad keys add jmc
gaiad tx staking create-validator \
  --amount=800000uatom \
  --pubkey=$(gaiad tendermint show-validator) \
  --moniker="jmc22" \
  --chain-id=theta-testnet-001 \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="50000" \
  --gas-prices="0.0030uatom" \
  --from=cosmos1r5z7ehvna78ed4yy9453wv7kq694vgpmsmhnxd
