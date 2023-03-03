
/**
 * # [aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster)
 * 
 * This module provides the CLOUDETEER standard for deploying Azure Kubernetes Cluster.
 * 
 * Naming for windows additional pools would be automatically adjusted to first and last three characters provided in the nodepools keys.(ref to examples in test dir)
 * aks_cluster_name = name of cluster tag is added by default to default and additional nodepools.
 * At this time there's a bug in the AKS API where Tags for a Node Pool are not stored in the correct case
 * 
**/

terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.32.0"
    }
  }
}

