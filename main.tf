data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

locals {
  base_cidr_block = var.address
}

data "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_virtual_network" "spokevnet" {
  name                = "${var.prefix}-vnet"
  address_space       = [local.base_cidr_block]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

    dynamic "subnet" {
      for_each = [for s in var.subnets : {
        name   = s.name
        prefix = cidrsubnet("${local.base_cidr_block}", var.newbits, s.number)
      }]
  
      content {
        name           = subnet.value.name
        address_prefix = subnet.value.prefix
        security_group = azurerm_network_security_group.nsg.id             
      }
    }
}
