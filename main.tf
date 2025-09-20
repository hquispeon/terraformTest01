terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ---------------------------
# Resource Group
# ---------------------------
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-aks"
  location = "East US"
}

# ---------------------------
# Log Analytics Workspace (Azure Monitor)
# ---------------------------
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-terraform-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# ---------------------------
# AKS Cluster
# ---------------------------
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-terraform-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-terraform"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }
}

# ---------------------------
# Application Gateway
# ---------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-terraform-aks"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet_appgw" {
  name                 = "subnet-appgw"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "appgw_pip" {
  name                = "pip-appgw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "appgw" {
  name                = "appgw-terraform"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.subnet_appgw.id
  }

  frontend_ip_configuration {
    name                 = "appgw-feip"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  frontend_port {
    name = "appgw-feport"
    port = 80
  }

  backend_address_pool {
    name = "appgw-bepool"
  }

  backend_http_settings {
    name                  = "appgw-behttpsettings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "appgw-httplistener"
    frontend_ip_configuration_name = "appgw-feip"
    frontend_port_name             = "appgw-feport"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "appgw-rulename"
    rule_type                  = "Basic"
    http_listener_name         = "appgw-httplistener"
    backend_address_pool_name  = "appgw-bepool"
    backend_http_settings_name = "appgw-behttpsettings"
  }
}
