# Install gaia binary
FROM golang:1.18 as gaia-builder
RUN git clone -b v7.0.3 https://github.com/cosmos/gaia.git; \
    cd /go/gaia; \
    git checkout v7.0.3; \
    CGO_ENABLED=0 GOOS=linux make install; \
    git checkout main;

# Get genesis file
FROM alpine:3.15.6 as genesis-builder
RUN wget https://github.com/hyphacoop/testnets/raw/add-theta-testnet/v7-theta/public-testnet/genesis.json.gz; \
    gunzip genesis.json.gz;

FROM alpine:3.15.6
# Get gaia binary and genesis file unziped from builder stages
COPY --from=gaia-builder /go/bin/gaiad /usr/bin/
COPY --from=genesis-builder genesis.json $HOME/.gaia/config/
# Copy scripts
COPY src/config.sh .
COPY src/launch-node.sh .
COPY src/create-validator.sh .
COPY src/update-node-config-for-horcrux.sh .
# Add curl
RUN apk add --update curl && \
    rm -rf /var/cache/apk/*
# Make shell cripts executable
RUN ["chmod", "+x", "./launch-node.sh"]
RUN ["chmod", "+x", "./create-validator.sh"]
RUN ["chmod", "+x", "./update-node-config-for-horcrux.sh"]
CMD ["/bin/sh", "./launch-node.sh"]
EXPOSE 26656
EXPOSE 26657
EXPOSE 1234
