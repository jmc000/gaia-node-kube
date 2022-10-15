# CosmosHub blockchain validator node deployment
This repository provides resources to ship a [CosmosHub](https://hub.cosmos.network/main/hub-overview/overview.html) validator node on a [Kubernetes](https://kubernetes.io/) cluster.

*Disclaimer: this is a WIP PoC*


# Project architecture

You can find the more detailed explanation of the infrastructure [here](infrastructure.md)
## Docker images

Dockerfiles are provided in `/docker` folder for [gaia node](https://github.com/cosmos/gaia), [horcrux](https://github.com/strangelove-ventures/horcrux) multi-party signer and private key KMS.
Those are pushed on the DockerHub [here](https://hub.docker.com/r/jeremymc99/gaia) if needed.

## Kubernetes
An example of GKE cluster provisioning is provided as code in `/terraform` folder if you do not have an already running cluster.
The Kubernetes ressources to be deployed are defined in `/k8s` folder.

# Getting started

Are you ready to become a cosmonaut?

## Prerequisites

[Install Docker](https://docs.docker.com/get-docker/)

## Build Docker images
```console
foo@bar:gaia-node-kube$ docker build -t <my-image-name>:<my-tag> docker/node
foo@bar:gaia-node-kube$ docker build -t <my-image-name>:<my-tag> docker/horcrux
```
Think to change the images used by kubernetes deployment if you want to use your own tags or registry.

## Configure .sh
TODO: ajouter la config pour la clé privée quand c'est fait

TODO: ajouter votre encrypted private key et apply du secret (rajouter un stage create secret pkey dans le makefile)

## Launching kubernetes resources
To start a gaia node and create your validator:
```console
foo@bar:gaia-node-kube$ make
```

You can check the synchronisation state like that:
```console
foo@bar:gaia-node-kube$ kubectl logs <gaia-node-pod-name> -f
```

When the node is fully synchronise then you can configure your validator to use the Horcrux single threshold signer.
```console
foo@bar:gaia-node-kube$ make k8s-restart-node-for-horcrux
```
