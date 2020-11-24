```shell script
# cd challenge/terraform
terraform apply
export KUBECONFIG=$(terraform output kube_config)

# cd challenge/charts
helmfile deps

# First time run, concurrency required
helmfile -i apply --concurrency 1
```

# TODO
* LOKI Stack
* https://github.com/dexidp/dex
* https://github.com/heptiolabs/gangway

# Advanced TODO
* ArgoCD
* Istio
