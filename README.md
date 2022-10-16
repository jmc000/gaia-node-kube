# CosmosHub blockchain validator node deployment
This repository provides resources to ship a [CosmosHub](https://hub.cosmos.network/main/hub-overview/overview.html) validator node on a [Kubernetes](https://kubernetes.io/) cluster on GCP.  
It is using Horcrux for remote signer and a Secret Manager for private keys.

**Disclaimer:** this is a WIP PoC

# Project architecture

You can find an illustration of the infrastructure [here](infrastructure.png)
## Docker images

Dockerfiles are provided in `/docker` folder for [gaia node](https://github.com/cosmos/gaia), [horcrux](https://github.com/strangelove-ventures/horcrux) multi-party signer and secret-manager-api (image using GCP go SDK for getting secrets from Google Secret Manager).
Those are pushed on the DockerHub [here](https://hub.docker.com/r/jeremymc99/gaia) if needed.

## Kubernetes
An example of GKE cluster provisioning is provided as code in `/terraform` folder if you do not have an already running cluster.
The Kubernetes ressources to be deployed are defined in `/k8s` folder.

# Getting started

Are you ready to become a cosmonaut?

## Prerequisites

[Install Docker](https://docs.docker.com/get-docker/)  
Install Make  
Configure GCP CLI

## Build Docker images
```console
foo@bar:gaia-node-kube$ docker build -t <my-image-name>:<my-tag> docker/node
foo@bar:gaia-node-kube$ docker build -t <my-image-name>:<my-tag> docker/horcrux
foo@bar:gaia-node-kube$ docker build -t <my-image-name>:<my-tag> docker/secret-manager
```
Think to change the images used by kubernetes deployments if you want to use your own tags or registry.

## Private Key
Export your gaia private key with `gaia keys export foo` command, enter a password and keep it in mind.   
Now, add your encrypted private pkey file (the output) in the secret k8s resource ([here](k8s/node/secret-priv-key.yaml))  
Then, rename the `.env-example` file in `.env`, and add your password in the file like that: `PASSWORD=<my-password>` 

## Provision the Kubernetes cluster
If you dont have one yet:
```console
foo@bar:gaia-node-kube/terraform$ terraform apply
```
```console
foo@bar:gaia-node-kube$ make get-gke-kube-config
```

## Configure Secret Manager
Add your private key password to Google Secret Manager:
```console
foo@bar:gaia-node-kube$ make configure-gcp-secret-manager
```

## Launching kubernetes resources
To start a gaia node and create your validator:
```console
foo@bar:gaia-node-kube$ make launch-gaia-node
```

When the node is fully synchronise then you can configure your validator to use the Horcrux single threshold signer.
```console
foo@bar:gaia-node-kube$ make k8s-restart-node-for-horcrux
```
