
locals {
  base_cidr_block = var.address
}

provider "azurerm" {
  alias = "src"
}


resource "azurerm_network_security_group" "nsg" {
  provider            = azurerm.src
  name                = "${var.prefix}-nsg"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  tags = var.tags
  lifecycle { ignore_changes = [tags] }
}

resource "azurerm_virtual_network" "spokevnet" {
  name                = "${var.prefix}-vnet"
  provider            = azurerm.src
  address_space       = [local.base_cidr_block]
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  dns_servers         = var.dns_servers
  tags                = var.tags
  lifecycle { ignore_changes = [tags] }


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
