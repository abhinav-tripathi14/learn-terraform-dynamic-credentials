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
