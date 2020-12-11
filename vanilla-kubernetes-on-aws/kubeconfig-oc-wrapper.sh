#!/bin/bash

# See: https://gist.github.com/jkroepke/5030b52f7e99b491c1a85f098d2d4280

set -eo pipefail
export SCOPE="kubeconfig-oc-wrapper-${CLUSTER_NAME:-default}"
export KUBECONFIG="${HOME}/.kube/${SCOPE}.config"

function readKeychain() {
    # https://www.linuxjournal.com/content/return-values-bash-functions

    local CREDENTIAL=""
    case $(uname) in
    "Darwin")
        CREDENTIAL="$(security find-generic-password -a "${SCOPE}" -s "$1" -w 2>/dev/null)"
        if [ "$?" -eq "44" ]; then
            read "${@:3}" -ep "$2" -r CREDENTIAL
            security add-generic-password -a "${SCOPE}" -s "$1" -w "${CREDENTIAL}"
        fi

        CREDENTIAL="$(security find-generic-password -a "${SCOPE}" -s "$1" -w 2>/dev/null)"
        ;;
    "Linux")
        CREDENTIAL="$(keyring get "${SCOPE}" "$1" 2>/dev/null)"
        if [ "$?" -ne "0" ]; then
            keyring set UHD "$1"
        fi

        CREDENTIAL="$(keyring get "${SCOPE}" "$1" 2>/dev/null)"
        ;;

    "*")
        read "${@:3}" -ep "$2:" -r CREDENTIAL
        ;;
    esac

    echo "${CREDENTIAL}"
}

function deleteKeychain() {
    case $(uname) in
    "Darwin")
        security delete-generic-password -a "${SCOPE}" -s "$1"
        ;;
    "Linux")
        echo TODO
        ;;

    "*")
        echo "No keychain found"
        ;;
    esac
}

touch "${KUBECONFIG}"

if ! oc get pods > /dev/null 2>&1; then
  echo "Logging in into ${CLUSTER_ADDR} ${SSL_VERIFY_NONE:+with --insecure-skip-tls-verify}" >&2

  OC_USERNAME="${OC_USERNAME:-"$(readKeychain USERNAME "Openshift Username: ")"}"
  echo ""
  OC_PASSWORD="${OC_PASSWORD:-"$(readKeychain PASSWORD "Openshift Password: " "-s")"}"
  echo ""

  if ! oc login "${CLUSTER_ADDR}" --username="${OC_USERNAME}" --password="${OC_PASSWORD}" ${SSL_VERIFY_NONE:+--insecure-skip-tls-verify} >&2; then
    deleteKeychain USERNAME > /dev/null 2>&1
    deleteKeychain PASSWORD > /dev/null 2>&1
    exit 1
  fi
fi


if [ "$(uname)" == "Darwin" ]; then
  EXP_DATE=$(date -u -v '+1H' +%Y-%m-%dT%TZ)
else
  EXP_DATE=$(date -u -d '+1 hours' +%Y-%m-%dT%TZ)
fi

echo '{
  "apiVersion": "'"${API_VERSION:-"client.authentication.k8s.io/v1beta1"}"'",
  "kind": "ExecCredential",
  "status": {
    "token": "'"$(oc whoami -t)"'",
    "expirationTimestamp": "'"${EXP_DATE}"'"
  }
}'
