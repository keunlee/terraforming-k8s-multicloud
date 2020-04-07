provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "rg" {
    name                = var.resource_group_name
    location            = var.location
}

resource "azurerm_container_registry" "acr" {
  name                      = var.acr_name
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  sku                       = "Basic"
  admin_enabled             = false
  network_rule_set          = []
#   georeplication_locations = ["East US"]
}

resource "azurerm_role_assignment" "aks_sp_container_registry" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = var.object_id
}

module "az-cluster-1" {
    source              = "../modules/azure/aks"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    client_id           = var.client_id
    client_secret       = var.client_secret
    object_id           = var.object_id
    prefix              = var.prefix
    cluster_name        = "azure-cluster-1"
    node_count          = var.node_count
}

module "az-cluster-2" {
    source              = "../modules/azure/aks"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    client_id           = var.client_id
    client_secret       = var.client_secret
    object_id           = var.object_id
    prefix              = var.prefix
    cluster_name        = "azure-cluster-2"
    node_count          = var.node_count
}