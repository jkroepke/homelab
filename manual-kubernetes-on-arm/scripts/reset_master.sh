#!/usr/bin/env bash

terraform -chdir=cluster-setup destroy -auto-approve \
  -target='module.kubernetes-control-plane.aws_instance.this["1"]' \
  -target='module.kubernetes-control-plane.aws_route53_record.etcd_member_A["1"]' \
  -target='module.kubernetes-control-plane.aws_lb_target_group_attachment.this["1"]' \
  -target='module.kubernetes-control-plane.aws_instance.this["2"]' \
  -target='module.kubernetes-control-plane.aws_route53_record.etcd_member_A["2"]' \
  -target='module.kubernetes-control-plane.aws_lb_target_group_attachment.this["2"]' \
  -target='module.kubernetes-control-plane.aws_instance.this["3"]' \
  -target='module.kubernetes-control-plane.aws_route53_record.etcd_member_A["3"]' \
  -target='module.kubernetes-control-plane.aws_lb_target_group_attachment.this["3"]'

terraform -chdir=cluster-setup apply -auto-approve
terraform -chdir=cluster apply -auto-approve
