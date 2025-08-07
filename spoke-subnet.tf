resource "azurerm_subnet" "spokesubnet" {
  for_each                        = { for subnet in var.subnets : subnet.name => subnet }
  name                            = each.value.name
  provider                        = azurerm.src
  resource_group_name             = var.resource_group.name
  virtual_network_name            = azurerm_virtual_network.spokevnet.name
  address_prefixes                = [cidrsubnet(local.base_cidr_block, try(each.value.newbits, var.newbits), each.value.number)]
  service_endpoints               = try(each.value.service_endpoints, var.service_endpoints)
  default_outbound_access_enabled = var.enable_outbound
  lifecycle { ignore_changes = [private_endpoint_network_policies] }
}

resource "azurerm_subnet" "spokesubnet_delegated" {
  for_each             = { for subnet in var.subnets_with_delegation : subnet.name => subnet }
  name                 = each.value.name
  provider             = azurerm.src
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.spokevnet.name
  address_prefixes     = [cidrsubnet(local.base_cidr_block, try(each.value.newbits, var.newbits), each.value.number)]
  service_endpoints    = try(each.value.service_endpoints, var.service_endpoints)
  delegation {
    name = replace(each.value.delegation.name, "/", ".")

    service_delegation {
      name    = each.value.delegation.name
      actions = try(each.value.delegation.actions, ["Microsoft.Network/virtualNetworks/subnets/action"])
    }
  }
  default_outbound_access_enabled = var.enable_outbound
  lifecycle { ignore_changes = [private_endpoint_network_policies] }
}

resource "azurerm_subnet_network_security_group_association" "spokesubnetnsg" {
  provider                  = azurerm.src
  for_each                  = azurerm_subnet.spokesubnet
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "spokesubnetdelegatednsg" {
  provider                  = azurerm.src
  for_each                  = azurerm_subnet.spokesubnet_delegated
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
