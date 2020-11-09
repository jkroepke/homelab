locals {
  controller1_user = "ubuntu"
  controller1_host = aws_instance.controller[keys(local.controller_nodes)[0]].private_ip
  controller1_port = 22

  bastion_user = "ubuntu"
  bastion_host = aws_eip.bastion.public_dns
  bastion_port = 22
}

resource "null_resource" "download-admin-config" {
  depends_on = [
    null_resource.controller-kickstart
  ]

  provisioner "local-exec" {
    command = join(" ", [
      "rsync",
      "--rsync-path='sudo rsync'",
      "-e",
      "\"",
      join(" ", [
        "ssh",
        "-oStrictHostKeyChecking=no",
        "-oUserKnownHostsFile=/dev/null",
        "-p ${local.controller1_port}",
        "-oProxyCommand=\\\"ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -W %h:%p -p ${local.bastion_port} ${local.bastion_user}@${local.bastion_host}\\\""
      ]),
      "\"",
      "${local.controller1_user}@${local.controller1_host}:/etc/kubernetes/admin.conf",
      ".local/admin.config"
    ])
  }
}
