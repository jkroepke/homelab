#!/usr/bin/env bash

index="$1"

terraform apply -target='module.kubernetes-control-plane.aws_instance.this["'"${index}"'"]' \
  -target='module.kubernetes-control-plane.aws_route53_record.etcd_member_A["'"${index}"'"]' \
  -target='module.kubernetes-control-plane.aws_lb_target_group_attachment.this["'"${index}"'"]'
