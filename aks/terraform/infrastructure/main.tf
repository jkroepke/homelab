locals {
  aks_key_vaults = ["kubernetes-dex"]

  dcr_linux = {
    description = "Métriques/logs des machines linux France Central"
    kind        = "Linux"
    name        = "DCR-LINUX-FR"
    performance_counter = {
      "perfcounter30" = {
        counter_specifiers = [
          "\\Processor Information(_Total)\\% Processor Time",
          "\\Processor Information(_Total)\\% Privileged Time",
          "\\Processor Information(_Total)\\% User Time",
          "\\Processor Information(_Total)\\Processor Frequency",
          "\\System\\Processes",
          "\\Process(_Total)\\Thread Count",
          "\\Process(_Total)\\Handle Count",
          "\\System\\System Up Time",
          "\\System\\Context Switches/sec",
          "\\System\\Processor Queue Length",
          "\\Memory\\% Committed Bytes In Use",
          "\\Memory\\Available Bytes",
          "\\Memory\\Committed Bytes",
          "\\Memory\\Cache Bytes",
          "\\Memory\\Pool Paged Bytes",
          "\\Memory\\Pool Nonpaged Bytes",
          "\\Memory\\Pages/sec",
          "\\Memory\\Page Faults/sec",
          "\\Process(_Total)\\Working Set",
          "\\Process(_Total)\\Working Set - Private",
        ]
        sampling_frequency_in_seconds = 30
        streams                       = ["Microsoft-Perf"]
      }
      "perfcounter60" = {
        counter_specifiers = [
          "\\LogicalDisk(_Total)\\% Disk Time",
          "\\LogicalDisk(_Total)\\% Disk Read Time",
          "\\LogicalDisk(_Total)\\% Disk Write Time",
          "\\LogicalDisk(_Total)\\% Idle Time",
          "\\LogicalDisk(_Total)\\Disk Bytes/sec",
          "\\LogicalDisk(_Total)\\Disk Read Bytes/sec",
          "\\LogicalDisk(_Total)\\Disk Write Bytes/sec",
          "\\LogicalDisk(_Total)\\Disk Transfers/sec",
          "\\LogicalDisk(_Total)\\Disk Reads/sec",
          "\\LogicalDisk(_Total)\\Disk Writes/sec",
          "\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer",
          "\\LogicalDisk(_Total)\\Avg. Disk sec/Read",
          "\\LogicalDisk(_Total)\\Avg. Disk sec/Write",
          "\\LogicalDisk(_Total)\\Avg. Disk Queue Length",
          "\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length",
          "\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length",
          "\\LogicalDisk(_Total)\\% Free Space",
          "\\LogicalDisk(_Total)\\Free Megabytes",
          "\\Network Interface(*)\\Bytes Total/sec",
          "\\Network Interface(*)\\Bytes Sent/sec",
          "\\Network Interface(*)\\Bytes Received/sec",
          "\\Network Interface(*)\\Packets/sec",
          "\\Network Interface(*)\\Packets Sent/sec",
          "\\Network Interface(*)\\Packets Received/sec",
          "\\Network Interface(*)\\Packets Outbound Errors",
          "\\Network Interface(*)\\Packets Received Errors",
        ]
        sampling_frequency_in_seconds = 60
        streams                       = ["Microsoft-Perf"]
      }
      "insight" = {
        counter_specifiers            = ["\\VmInsights\\DetailedMetrics"]
        sampling_frequency_in_seconds = 60
        streams                       = ["Microsoft-InsightsMetrics"]
      }
    }
    streams = [
      "Microsoft-Syslog",
      "Microsoft-Perf",
      "Microsoft-InsightsMetrics",
      "Microsoft-ServiceMap"
    ]
    syslog = {
      name           = "syslog"
      facility_names = ["*"]
      log_levels     = ["*"]
    }
  }
}

data "azurerm_client_config" "this" {}

resource "azurerm_resource_provider_registration" "ContainerService" {
  name = "Microsoft.ContainerService"

  feature {
    name       = "EnableWorkloadIdentityPreview"
    registered = true
  }

  feature {
    name       = "EnablePodIdentityPreview"
    registered = true
  }

  feature {
    name       = "EnableOIDCIssuerPreview"
    registered = true
  }

  feature {
    name       = "KubeletDisk"
    registered = true
  }

  feature {
    name       = "AKS-EnableDualStack"
    registered = true
  }
}
