variable "clusterToken" {
  type = string
  description = "token from AAD Application to login into AKS. kubelogin get-token --environment AzurePublicCloud --server-id 6dae42f8-4368-4678-94ff-3960e28e3630 --client-id 80faf920-1908-4b52-b5ef-a8e7bedfc67a --tenant-id <CHANGE THIS> --login devicecode | jq -r .status.token"
}
