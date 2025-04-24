variable "subscription_id" {
  description = "Subscription id "
  type = string
  default = "80725b9c-38b3-402c-872fec66539e39d9"
}

variable "location" {
    description = "location of service"
    type = string
    default = "eastus2"
}

variable "resource_group_name" {
  description = "resource group name"
  type = string
  default = "rg-jenkins-docker-aks"
  
}

variable "os" {
  description = "Operating system"
  type = string
  default = "Linux"
}

variable "aks_name" {
  description = "Name of the AKS cluster"
  type = string
  default = "aks-cluster-docker-jenkins"
}

variable "acr_name" {
    description = "Name of the ACR"
    type = string
    default = "acrjenkinsdocker"
  
}