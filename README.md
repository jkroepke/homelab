# kubernetes-the-hard-way

## Original

Based on: https://github.com/kelseyhightower/kubernetes-the-hard-way

## Challenged way

A more challenged Kubernetes the hard way

Changes to the original:

* AWS infrastructure
* Enabled AWS Cloud provider functionalities
* CNI based on AWS VPC + calico
* Most of the services should run in containers via static pods.
* Monitoring Stack
* CoreDNS
* nginx Ingress Controller
* cert-manager
* IAM with Keycloak
* https://github.com/kubernetes/node-problem-detector
