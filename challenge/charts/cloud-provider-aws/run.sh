#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$0")
export KUBECONFIG="${KUBECONFIG:-"${SCRIPT_DIR}/../../.local/admin.config"}"

helm upgrade -i -n kube-system cloud-provider-aws "${SCRIPT_DIR}"
