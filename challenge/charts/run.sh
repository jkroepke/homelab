#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")

export KUBECONFIG="${SCRIPT_DIR}/../.local/admin.config"

helm upgrade -i -n kube-system kube-router "kube-router"
helm upgrade -i -n kube-system cloud-provider-aws "cloud-provider-aws"
helm upgrade -i -n kube-system aws-ebs-csi-driver "aws-ebs-csi-driver"

helm upgrade -i -n kube-system node-problem-detector "node-problem-detector"
helm upgrade -i -n kube-system aws-node-termination-handler "aws-node-termination-handler"
helm upgrade -i -n kube-system aws-cluster-autoscaler-chart "cluster-autoscaler-chart"

helm upgrade --create-namespace -i -n ingress-nginx ingress-nginx "ingress-nginx"
helm upgrade --create-namespace -i -n cert-manager cert-manager "cert-manager"
helm upgrade --create-namespace -i -n cert-manager cert-manager-cluster-issuer "cert-manager-cluster-issuer"
helm upgrade --create-namespace -i -n kubernetes-dashboard kubernetes-dashboard kubernetes-dashboard

#- https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
#- https://github.com/keycloak/keycloak-operator
