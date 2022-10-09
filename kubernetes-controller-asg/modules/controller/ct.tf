data "ct_config" "this" {
  content = jsonencode({
    storage = {
      filesystems = [{
        name = "etcd"
        mount = {
          label           = "ETCD"
          device          = "/dev/nvme1n1"
          format          = "xfs"
          wipe_filesystem = false
        }
      }]
    }
    systemd = {
      units = [{
        name     = "var-lib-etcd.mount"
        enable   = true
        contents = <<EOF
[Unit]
Before=local-fs.target
[Mount]
What=/dev/nvme1n1
Where=/var/lib/etcd
Type=xfs
[Install]
WantedBy=local-fs.target
EOF
      }]
    }
  })
  strict       = true
  pretty_print = false
}
