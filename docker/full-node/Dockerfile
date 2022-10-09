FROM golang:1.18 as gaia-builder
RUN git clone -b v7.0.3 https://github.com/cosmos/gaia.git; \
    cd /go/gaia; \
    git checkout v7.0.3; \
    CGO_ENABLED=0 GOOS=linux make install; \
    git checkout main;

FROM alpine:3.15.6 as genesis-builder
RUN wget https://github.com/hyphacoop/testnets/raw/add-theta-testnet/v7-theta/public-testnet/genesis.json.gz; \
    gunzip genesis.json.gz;

FROM alpine:3.15.6
COPY --from=gaia-builder /go/bin/gaiad /usr/bin/
COPY --from=genesis-builder genesis.json $HOME/.gaia/config/
COPY src/config.sh /bin/
COPY src/launch-full-node.sh /bin/
RUN ["chmod", "+x", "/bin/launch-full-node.sh"]
ENTRYPOINT ["sh","/bin/launch-full-node.sh"]
EXPOSE 26656
EXPOSE 26657
