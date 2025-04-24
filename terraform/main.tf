provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
    name                = var.acr_name
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    sku                 = "Basic"
    admin_enabled       = false  
}

resource "azurerm_kubernetes_cluster" "aks" {
    name                = var.aks_name
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    dns_prefix          = "aks-cluster-docker-jenkins"

    default_node_pool {
        name                = "agentpool"
        node_count          = 1
        vm_size             = "Standard_B2ms"
    }

    identity {
        type = "SystemAssigned"
    }

    network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    }

}




resource "azurerm_role_assignment" "acr_pull" {
 
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope               = azurerm_container_registry.acr.id
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}


# Outputs
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}