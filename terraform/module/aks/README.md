<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.32.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.32.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aci_connector_linux"></a> [aci\_connector\_linux](#input\_aci\_connector\_linux) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_api_server_access_profile"></a> [api\_server\_access\_profile](#input\_api\_server\_access\_profile) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_auto_scaler_profile"></a> [auto\_scaler\_profile](#input\_auto\_scaler\_profile) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_azure_active_directory_role_based_access_control"></a> [azure\_active\_directory\_role\_based\_access\_control](#input\_azure\_active\_directory\_role\_based\_access\_control) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_confidential_computing"></a> [confidential\_computing](#input\_confidential\_computing) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_default_node_pool"></a> [default\_node\_pool](#input\_default\_node\_pool) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_http_proxy_config"></a> [http\_proxy\_config](#input\_http\_proxy\_config) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_identity"></a> [identity](#input\_identity) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_ingress_application_gateway"></a> [ingress\_application\_gateway](#input\_ingress\_application\_gateway) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_key_management_service"></a> [key\_management\_service](#input\_key\_management\_service) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_key_vault_secrets_provider"></a> [key\_vault\_secrets\_provider](#input\_key\_vault\_secrets\_provider) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_kubelet_identity"></a> [kubelet\_identity](#input\_kubelet\_identity) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_linux_profile"></a> [linux\_profile](#input\_linux\_profile) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_microsoft_defender"></a> [microsoft\_defender](#input\_microsoft\_defender) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_monitor_metrics"></a> [monitor\_metrics](#input\_monitor\_metrics) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_network_profile"></a> [network\_profile](#input\_network\_profile) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_oms_agent"></a> [oms\_agent](#input\_oms\_agent) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_service_principal"></a> [service\_principal](#input\_service\_principal) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_storage_profile"></a> [storage\_profile](#input\_storage\_profile) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_web_app_routing"></a> [web\_app\_routing](#input\_web\_app\_routing) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_windows_profile"></a> [windows\_profile](#input\_windows\_profile) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_workload_autoscaler_profile"></a> [workload\_autoscaler\_profile](#input\_workload\_autoscaler\_profile) | n/a | <pre>object(<br>  )</pre> | n/a | yes |
| <a name="input_automatic_channel_upgrade"></a> [automatic\_channel\_upgrade](#input\_automatic\_channel\_upgrade) | n/a | `string` | `null` | no |
| <a name="input_azure_policy_enabled"></a> [azure\_policy\_enabled](#input\_azure\_policy\_enabled) | n/a | `bool` | `null` | no |
| <a name="input_disk_encryption_set_id"></a> [disk\_encryption\_set\_id](#input\_disk\_encryption\_set\_id) | n/a | `string` | `null` | no |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | n/a | `string` | `null` | no |
| <a name="input_dns_prefix_private_cluster"></a> [dns\_prefix\_private\_cluster](#input\_dns\_prefix\_private\_cluster) | n/a | `string` | `null` | no |
| <a name="input_edge_zone"></a> [edge\_zone](#input\_edge\_zone) | n/a | `string` | `null` | no |
| <a name="input_enable_pod_security_policy"></a> [enable\_pod\_security\_policy](#input\_enable\_pod\_security\_policy) | n/a | `bool` | `null` | no |
| <a name="input_http_application_routing_enabled"></a> [http\_application\_routing\_enabled](#input\_http\_application\_routing\_enabled) | n/a | `bool` | `null` | no |
| <a name="input_image_cleaner_enabled"></a> [image\_cleaner\_enabled](#input\_image\_cleaner\_enabled) | n/a | `bool` | `null` | no |
| <a name="input_image_cleaner_interval_hours"></a> [image\_cleaner\_interval\_hours](#input\_image\_cleaner\_interval\_hours) | n/a | `number` | `null` | no |
| <a name="input_local_account_disabled"></a> [local\_account\_disabled](#input\_local\_account\_disabled) | n/a | `bool` | `null` | no |
| <a name="input_oidc_issuer_enabled"></a> [oidc\_issuer\_enabled](#input\_oidc\_issuer\_enabled) | n/a | `bool` | `null` | no |
| <a name="input_open_service_mesh_enabled"></a> [open\_service\_mesh\_enabled](#input\_open\_service\_mesh\_enabled) | n/a | `bool` | `null` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | n/a | `bool` | `null` | no |
| <a name="input_private_cluster_public_fqdn_enabled"></a> [private\_cluster\_public\_fqdn\_enabled](#input\_private\_cluster\_public\_fqdn\_enabled) | n/a | `bool` | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | n/a | `bool` | `null` | no |
| <a name="input_role_based_access_control_enabled"></a> [role\_based\_access\_control\_enabled](#input\_role\_based\_access\_control\_enabled) | n/a | `bool` | `null` | no |
| <a name="input_run_command_enabled"></a> [run\_command\_enabled](#input\_run\_command\_enabled) | n/a | `bool` | `null` | no |
| <a name="input_sku_tier"></a> [sku\_tier](#input\_sku\_tier) | n/a | `string` | `"Free"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_workload_identity_enabled"></a> [workload\_identity\_enabled](#input\_workload\_identity\_enabled) | n/a | `bool` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->