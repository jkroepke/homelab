resource "azurerm_role_definition" "stop_start_vm" {
  name        = "StopStartVM"
  scope       = data.azurerm_subscription.current.id
  description = "Allow stopping and starting VMs in the primary subscription"

  permissions {
    actions = ["Microsoft.Network/*/read",
      "Microsoft.Compute/*/read",
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/restart/action",
      "Microsoft.Compute/virtualMachines/deallocate/action"
    ]
    not_actions = []
  }
}

resource "azurerm_user_assigned_identity" "vm-stop-start-automation" {
  resource_group_name = azurerm_resource_group.jok-default.name
  location            = azurerm_resource_group.jok-default.location

  name = "vm-stop-start-automation"
}

resource "azurerm_role_assignment" "vm-stop-start-automation" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = azurerm_role_definition.stop_start_vm.role_definition_resource_id
  principal_id       = azurerm_user_assigned_identity.vm-stop-start-automation.principal_id
}

resource "azurerm_automation_account" "vm-stop-start-automation" {
  name                = "vm-stop-start-automation"
  location            = azurerm_resource_group.jok-default.location
  resource_group_name = azurerm_resource_group.jok-default.name
  sku_name            = "Basic"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.vm-stop-start-automation.id]
  }
}

resource "azurerm_automation_runbook" "shutdownstart-vms-by-tag" {
  name = "ShutDownStartByTag"

  location            = azurerm_resource_group.jok-default.location
  resource_group_name = azurerm_resource_group.jok-default.name

  automation_account_name = azurerm_automation_account.vm-stop-start-automation.name

  log_progress = false
  log_verbose  = false

  runbook_type = "PowerShellWorkflow"

  publish_content_link {
    uri = "https://raw.githubusercontent.com/azureautomation/shutdownstart-vms-by-tag/master/shutdownstartbytag.ps1"
  }
}
