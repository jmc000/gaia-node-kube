#!/bin/bash -i

sed -i 's#priv_validator_laddr = ""#priv_validator_laddr = "tcp://0.0.0.0:1234"#g' /root/.gaia/config/config.toml
