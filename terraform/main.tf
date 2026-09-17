terraform {
 required_version = ">= 1.5.0"
 required_providers {
   azurerm = {
     source  = "hashicorp/azurerm"
     version = "~> 3.90"
   }
 }
}
provider "azurerm" {
 features {}
}
# Variables
variable "location" {
 type    = string
 default = "southafricanorth"
}
variable "project" {
 type    = string
 default = "fraud-bot"
}
# 1. Resource Group
resource "azurerm_resource_group" "rg" {
 name     = "rg-${var.project}-k8s-lab"
 location = var.location
 tags = {
   environment = "lab"
   owner       = "luto"
   purpose     = "k8s-architect-demo"
 }
}
# 2. AKS Cluster - For multitenancy demo
resource "azurerm_kubernetes_cluster" "aks" {
 name                = "aks-${var.project}-lab"
 location            = azurerm_resource_group.rg.location
 resource_group_name = azurerm_resource_group.rg.name
 dns_prefix          = "${var.project}-lab"
 kubernetes_version = "1.29.2"
 # System node pool
 default_node_pool {
   name                = "system"
   node_count          = 2
   vm_size             = "Standard_DS2_v2"
   os_disk_size_gb     = 30
   enable_auto_scaling = true
   min_count           = 2
