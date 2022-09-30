FROM golang:1.18 as builder
RUN git clone -b v7.0.3 https://github.com/cosmos/gaia.git; \
    cd /go/gaia; \
    git checkout v7.0.3; \
    CGO_ENABLED=0 GOOS=linux make install; \
    git checkout main;

FROM alpine:3.15.6
USER 1000
COPY --from=builder /go/bin/gaiad /bin/
ENTRYPOINT ["gaiad"]
