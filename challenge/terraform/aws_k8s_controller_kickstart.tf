resource "null_resource" "controller-kickstart" {
  for_each = aws_instance.controller

  triggers = {
    id = each.value.id
  }

  depends_on = [
    aws_lb_listener.k8s-api,
    aws_lb_target_group_attachment.k8s-api
  ]

  provisioner "remote-exec" {
    # /usr/local/bin/instance-kickstart controller0 joe-k8s-sandbox.adorsys-sandbox.aws.adorsys.de
    inline = [
      "/bin/sudo /usr/local/bin/control-plan-kickstart ${each.key} ${aws_route53_record.api.name}"
    ]

    connection {
      type = "ssh"
      host = each.value.private_ip
      port = 22
      user = "ubuntu"

      bastion_host = aws_eip.bastion.public_dns
      bastion_port = 22
      bastion_user = "ubuntu"
    }
  }
}
