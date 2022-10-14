k8s-launch-node:
	kubectl apply -f k8s/namespace.yaml
	sleep 5
	kubens gaia
	kubectl apply -f k8s/node 
	kubectl apply -f k8s/horcrux 
	kubectl apply -f k8s/jobs/validator

k8s-restart-node-for-horcrux:
	kubectl apply -f k8s/jobs/horcrux
