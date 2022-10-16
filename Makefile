#!make
include .env
export PROJECT_ID=gaia-node-on-kube

# Launch all k8s resources for gaia node
launch-gaia-node:
	kubectl apply -f k8s/namespace.yaml
	kubens gaia
	kubectl apply -f k8s/secret-manager
	kubectl apply -f k8s/node
	kubectl apply -f k8s/horcrux
	kubectl apply -f k8s/jobs/rbac.yaml
	kubectl apply -f k8s/jobs/validator

# Change node config in order to use Horcrux for signing key
use-horcrux-remote-signer:
	kubectl apply -f k8s/jobs/horcrux

# Before make sure Google Secret Manager (GSM) is enabled
configure-gcp-secret-manager:
	# Create secret in GSM
	echo -n ${PASSWORD} | gcloud secrets create my-pkey-password \
    		--project ${PROJECT_ID} \
    		--replication-policy automatic \
    		--data-file=-
	
	# Create Google Service Account (GSA)
	gcloud iam service-accounts create secret-gsa --project ${PROJECT_ID}

	# Grant GSA the secretAccessor role on the secret
	gcloud secrets add-iam-policy-binding my-pkey-password \
    		--project ${PROJECT_ID} \
    		--member="serviceAccount:secret-gsa@${PROJECT_ID}.iam.gserviceaccount.com" \
    		--role="roles/secretmanager.secretAccessor" 
	
	# Create K8S Service Account
	kubectl create sa --namespace gaia secret-ksa

	# Allow SA to impersonate the GSA
	gcloud iam service-accounts add-iam-policy-binding \
    		secret-gsa@${PROJECT_ID}.iam.gserviceaccount.com \
    		--role roles/iam.workloadIdentityUser \
    		--member "serviceAccount:${PROJECT_ID}.svc.id.goog[gaia/secret-ksa]"

	# Annotate the KSA
	kubectl annotate serviceaccount \
    		--namespace gaia secret-ksa  \
    		iam.gke.io/gcp-service-account=secret-gsa@${PROJECT_ID}.iam.gserviceaccount.com

# Get GKE Kubeconfig
get-gke-kube-config:
	gcloud container clusters get-credentials gaia-node-on-kube-gke \
    		--project ${PROJECT_ID} \
    		--region europe-west4
