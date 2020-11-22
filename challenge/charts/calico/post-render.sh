#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cat - > "${DIR}/kustomize/all.yaml"
kubectl kustomize "${DIR}/kustomize"
rm "${DIR}/kustomize/all.yaml"
