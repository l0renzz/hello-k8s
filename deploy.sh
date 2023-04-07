#!/bin/bash
minikube start --driver=docker
eval $(minikube docker-env)
docker build -t hello-k8s-go ./services/hello-k8s
kubectl apply -f hello-k8s.yaml