#!/usr/bin/env bash

# Set port forwarding for the minikube vm to forward port 8443 on 127.0.0.1 to port 8443 in the VM.
VBoxManage controlvm minikube natpf1 k8s-apiserver,tcp,127.0.0.1,8443,,8443

# Create a new kubectl context
kubectl config set-cluster minikube-vpn --server=https://127.0.0.1:8443 --insecure-skip-tls-verify
kubectl config set-context minikube-vpn --cluster=minikube-vpn --user=minikube
kubectl config use-context minikube-vpn

VBoxManage controlvm minikube natpf1 k8s-dashboard,tcp,127.0.0.1,30000,,30000