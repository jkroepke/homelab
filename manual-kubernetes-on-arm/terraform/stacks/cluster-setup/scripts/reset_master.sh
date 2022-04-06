#!/usr/bin/env bash

terraform destroy -auto-approve \
  -target='module.kubernetes-control-plane.module.controller["0"].aws_autoscaling_group.this' \
  -target='module.kubernetes-control-plane.module.controller["0"].aws_ebs_volume.this' \
  -target='module.kubernetes-control-plane.module.controller["1"].aws_autoscaling_group.this' \
  -target='module.kubernetes-control-plane.module.controller["1"].aws_ebs_volume.this' \
  -target='module.kubernetes-control-plane.module.controller["2"].aws_autoscaling_group.this' \
  -target='module.kubernetes-control-plane.module.controller["2"].aws_ebs_volume.this'

terraform apply -auto-approve
