#!/bin/bash -i

horcrux config init theta-testnet-001 "tcp://gaia-full-node-svc.gaia:1234" -l "tcp://horcrux-svc.gaia:2222" --home .horcrux
cp /root/.gaia/config/priv_validator_key.json .horcrux
horcrux signer start --home .horcrux
