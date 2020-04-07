resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.prefix

  default_node_pool {
    name              = var.node_pool_name
    node_count        = var.node_count
    vm_size           = var.vm_size
  }

  service_principal {
    client_id         = var.client_id
    client_secret     = var.client_secret
  }

  tags = {
    Environment       = "Production"
  }
}