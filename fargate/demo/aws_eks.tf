module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.5.0"

  role_name             = "vpc_cni"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name                    = local.cluster_name
  cluster_version                 = var.eks_cluster_version
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    # Note: https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html#fargate-gs-coredns
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
      addon_version            = "v1.11.3-eksbuild.1"
    }
  }

  vpc_id     = module.vpc.id
  subnet_ids = values(module.vpc.private_subnets)

  eks_managed_node_group_defaults = {
    iam_role_attach_cni_policy = true
  }

  # You require a node group to schedule coredns which is critical for running correctly internal DNS.
  # If you want to use only fargate you must follow docs `(Optional) Update CoreDNS`
  # available under https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html
  eks_managed_node_groups = {
    default = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t4g.large"]
      capacity_type  = "SPOT"
      ami_type       = "BOTTLEROCKET_ARM_64"
    }
  }

  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
          labels = {
            WorkerType = "fargate"
          }
        }
      ]

      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }
  }
}
