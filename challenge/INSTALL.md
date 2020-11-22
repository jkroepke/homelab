```shell script
# cd challenge/terraform
terraform apply
export KUBECONFIG=$(terraform output kube_config)
# cd challenge/charts
helm upgrade -i -n kube-system cloud-provider-aws "cloud-provider-aws"

#helm upgrade -i -n kube-system kube-router "kube-router"
helm upgrade -i -n kube-system calico "calico" --post-renderer calico/post-render.sh 

helm upgrade -i -n kube-system aws-ebs-csi-driver "aws-ebs-csi-driver"
helm upgrade -i -n kube-system aws-efs-csi-driver "aws-efs-csi-driver"
helm upgrade -i -n kube-system aws-node-termination-handler "aws-node-termination-handler"
helm upgrade -i -n kube-system cluster-autoscaler "cluster-autoscaler"

helm upgrade -i -n kube-system node-problem-detector "node-problem-detector"

helm upgrade --create-namespace -i -n ingress-nginx ingress-nginx "ingress-nginx"
helm upgrade --create-namespace -i -n cert-manager cert-manager "cert-manager"
helm upgrade --create-namespace -i -n cert-manager cert-manager-cluster-issuer "cert-manager-cluster-issuer"
helm upgrade --create-namespace -i -n kubernetes-dashboard kubernetes-dashboard "kubernetes-dashboard"
helm upgrade --create-namespace -i -n k8s-event-logger k8s-event-logger "k8s-event-logger"

helm upgrade --create-namespace -i -n monitoring monitoring "kube-prometheus-stack""
```

# TODO
* Restrict AWS Metadata
* https://github.com/kubernetes-sigs/aws-ebs-csi-driver#prerequisites
* https://github.com/keycloak/keycloak-operator
