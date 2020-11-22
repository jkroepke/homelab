```shell script
# cd challenge/terraform
terraform apply
export KUBECONFIG=$(terraform output kube_config)

# cd challenge/charts
helmfile deps
helmfile -i apply
```

# TODO
* LOKI
* https://github.com/dexidp/dex
* https://github.com/heptiolabs/gangway

