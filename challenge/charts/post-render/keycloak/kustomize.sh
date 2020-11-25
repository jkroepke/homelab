#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

finish() {
  rm -rf"${DIR}/all.yaml"
}

trap finish EXIT

cat - > "${DIR}/all.yaml"
kubectl kustomize "${DIR}"
