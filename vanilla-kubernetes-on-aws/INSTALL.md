# Requirements

```shell script
brew install helm terraform helmfile

helm plugin install https://github.com/aslafy-z/helm-git --version 0.10.0
helm plugin install https://github.com/databus23/helm-diff
```

# Installation

```shell script
# cd challenge/terraform
terraform init

terraform apply
export KUBECONFIG=$(terraform output kube_config)

# cd challenge/charts
helmfile -i apply
```

## User login

Via https://github.com/int128/kubelogin
```
kubectl oidc-login setup \
    --oidc-issuer-url=https://login.joe-k8s-sandbox.adorsys-sandbox.aws.adorsys.de/auth/realms/kubernetes \
    --oidc-client-id=kubernetes \
    --oidc-client-secret=kubernetes                
```


# Soft Reset
```shell script
terraform taint 'aws_instance.controller["controller1"]'
terraform taint 'aws_instance.controller["controller2"]'
terraform taint 'aws_instance.controller["controller3"]'

terraform taint 'aws_autoscaling_group.worker["eu-central-1a"]'
terraform taint 'aws_autoscaling_group.worker["eu-central-1b"]' 
terraform taint 'aws_autoscaling_group.worker["eu-central-1c"]'
```

# TODO

# Advanced TODO
* ArgoCD
* Istio
* Metric Beat

* crossplane.io

* Werf
* FlexCD
* Spinnaker
* Tekton
