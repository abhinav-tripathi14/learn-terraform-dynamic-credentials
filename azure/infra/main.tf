provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
}
  subscription_id = "57ad2e58-e56c-4ba8-b326-f8a11cf2781a"
  client_id       = "9efe8bf7-32da-41c4-8f78-c070f7dc38d9"
  tenant_id       = "56f775a3-2540-4f05-ab58-72cd72d17d3e"
  use_oidc        = true
  }

provider "azapi" {
  subscription_id = "57ad2e58-e56c-4ba8-b326-f8a11cf2781a"
  client_id       = "9efe8bf7-32da-41c4-8f78-c070f7dc38d9"
  tenant_id       = "56f775a3-2540-4f05-ab58-72cd72d17d3e"
  use_oidc = true
}

resource "azurerm_resource_group" "example" {
  name     = "exampleTFResourceGroup"
  location = var.azure_location
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "cosmosdb-abhinav"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
 offer_type         = "Standard"
 kind               = "GlobalDocumentDB"
 create_mode        = null
 consistency_policy {
   consistency_level      = "BoundedStaleness"
   max_interval_in_seconds = 5
   max_staleness_prefix   = 100
 }
 geo_location {
   location         = azurerm_resource_group.example.location
   failover_priority = 0
   zone_redundant   = false
 }
 capacity {
   total_throughput_limit = -1
 }


 public_network_access_enabled     = false
 is_virtual_network_filter_enabled = true
 access_key_metadata_writes_enabled = false
 lifecycle {
   ignore_changes = [
     public_network_access_enabled,
     ip_range_filter
   ]
 }

}
resource "azapi_resource" "cosmos" {
  type = "Microsoft.DocumentDB/databaseAccounts@2024-08-15"

  name      = "cosmosdb-via-azapi"
  parent_id = azurerm_resource_group.example.id
  location  = azurerm_resource_group.example.location

  body = {
    kind = "GlobalDocumentDB"

    properties = {
      databaseAccountOfferType = "Standard"

      consistencyPolicy = {
        defaultConsistencyLevel = "Session"
      }

      locations = [
        {
          locationName     = azurerm_resource_group.example.location
          failoverPriority = 0
          isZoneRedundant  = false
        }
      ]
      disableLocalAuth = false
      publicNetworkAccess = "Enabled"
      minimalTlsVersion = "Tls12"
    }
  }
  response_export_values = [
    "properties.documentEndpoint"
  ]
}
