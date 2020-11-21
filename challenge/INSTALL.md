```shell script
# cd challenge/terraform
terraform apply
export KUBECONFIG=$(terraform output kube_config)
# cd challenge/charts
helm upgrade -i -n kube-system kube-router "kube-router"

helm upgrade -i -n kube-system cloud-provider-aws "cloud-provider-aws"
helm upgrade -i -n kube-system aws-ebs-csi-driver "aws-ebs-csi-driver"
helm upgrade -i -n kube-system aws-efs-csi-driver "aws-efs-csi-driver"
helm upgrade -i -n kube-system aws-node-termination-handler "aws-node-termination-handler"
helm upgrade -i -n kube-system aws-cluster-autoscaler-chart "cluster-autoscaler-chart"

helm upgrade -i -n kube-system node-problem-detector "node-problem-detector"

helm upgrade --create-namespace -i -n ingress-nginx ingress-nginx "ingress-nginx"
helm upgrade --create-namespace -i -n nginx-ingress nginx-ingress "nginx-ingress"
helm upgrade --create-namespace -i -n cert-manager cert-manager "cert-manager"
helm upgrade --create-namespace -i -n cert-manager cert-manager-cluster-issuer "cert-manager-cluster-issuer"
helm upgrade --create-namespace -i -n kubernetes-dashboard kubernetes-dashboard kubernetes-dashboard
```

# TODO
* https://github.com/projectcalico/calico/tree/master/_includes/charts/calico/templates
* https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
* https://github.com/keycloak/keycloak-operator
