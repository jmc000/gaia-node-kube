FROM ubuntu:22.10 as builder
RUN apt-get update && apt-get install wget -y && rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/strangelove-ventures/horcrux/releases/download/v2.0.0/horcrux_2.0.0_linux_amd64.tar.gz; \
    tar -xzf horcrux_2.0.0_linux_amd64.tar.gz
RUN mv horcrux /usr/bin/horcrux; \
    rm horcrux_2.0.0_linux_amd64.tar.gz README.md LICENSE.md
COPY src/launch-horcrux.sh .
RUN ["chmod", "+x", "./launch-horcrux.sh"]
CMD ["/bin/sh", "./launch-horcrux.sh"]
EXPOSE 2222
