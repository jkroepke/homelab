resource "aws_launch_template" "this" {
  name                   = "${var.cluster_name}-node"
  update_default_version = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      encrypted             = true
      iops                  = 3000
      volume_size           = var.volume_size
      volume_type           = "gp3"
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_termination = false
  ebs_optimized           = true

  iam_instance_profile {
    name = module.iam-instance-profile.iam_instance_profile_name
  }

  image_id = var.ami_image_id
  key_name = var.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
  }

  private_dns_name_options {
    hostname_type                        = "resource-name"
    enable_resource_name_dns_a_record    = true
    enable_resource_name_dns_aaaa_record = true
  }

  user_data              = base64encode(module.user_data.rendered)
  vpc_security_group_ids = var.vpc_security_group_ids

  tag_specifications {
    resource_type = "instance"

    tags = {
      project                                     = var.cluster_name
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  }
}
