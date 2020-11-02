# Kubernetes: The Hard Way - Double extrem challenge

This is just for learning purpose. 

Use kubeadm or kops for production setup.

Follow this:
https://github.com/kubernetes/kubeadm/blob/bb95b3a636cebb74e4d07bfb0b0f1f29cfc7a273/docs/design/design_v1.10.md


## Infrastructure

* VPC, Subnets with Internet Access
* 1 Bastion
* 3 Controller
* DNS Zone
* NLB (Port 6443) -> 3 Controller

## etcd

### Setup PKI

Based on: https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/#check-certificate-expiration

* etcd-ca
* etcd-healthcheck-client
* etcd-peer 
* etcd-server
* apiserver-etcd-client

## Kubernetes

### Setup PKI

Upstream: 
* https://kubernetes.io/docs/setup/best-practices/certificates/

# Bootstrap Process

* Install git and ansible via cloud-init
* Kickstart ansible via ansible-pull
* Install kublet
* run etcd as static pod and kickstart cluster via dns discovery
* all everything else

