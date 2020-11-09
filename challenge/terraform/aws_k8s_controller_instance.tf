resource "aws_instance" "controller" {
  for_each = local.controller_nodes

  // e2-standard-2
  ami               = data.aws_ami.ubuntu.id
  instance_type     = lookup(each.value, "instance_type", "t3a.large")
  availability_zone = each.value.availability_zone
  subnet_id         = each.value.subnet_id

  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh.key_name

  iam_instance_profile = aws_iam_instance_profile.controller.name

  vpc_security_group_ids = [
    aws_security_group.controller.id
  ]

  ebs_optimized = true

  user_data = data.template_cloudinit_config.controller[each.key].rendered

  // ip forward
  source_dest_check = false

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 50
  }

  lifecycle {
    ignore_changes = [
      ami,
      user_data,
      user_data_base64,
    ]
  }

  tags = {
    Name = "${var.name}-${each.key}"
    project = var.name

    "kubernetes.io/cluster/${var.name}" = "owned"
  }
}

# - cloud-init-per once -- /usr/local/bin/instance-kickstart ${instance_name}

/*
resource "aws_ebs_volume" "controller_etcd" {
  for_each = local.controller_nodes

  availability_zone = each.value.availability_zone
  size              = 20

  tags = {
    Name     = "${each.key}-etcd"
    project = var.name
  }
}

resource "aws_volume_attachment" "controller_etcd" {
  for_each = {for name, instance in aws_instance.controller : name => {
    instance_id = instance.id
    volume_id   = aws_ebs_volume.controller_etcd[name].id
  }}

  device_name = "/dev/xvdf"
  volume_id   = each.value.volume_id
  instance_id = each.value.instance_id
}
*/
