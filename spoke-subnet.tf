resource "azurerm_subnet" "spokesubnet" {
  count                = length(var.subnets)
  name                 = var.subnets[count.index].name
  provider             = azurerm.src
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.spokevnet.name
  address_prefixes     = [cidrsubnet(local.base_cidr_block, try(var.subnets[count.index].newbits,var.newbits), var.subnets[count.index].number)]
  service_endpoints    = try(var.subnets[count.index].service_endpoints, var.service_endpoints)
  lifecycle { ignore_changes = [private_endpoint_network_policies] }
} 

resource "azurerm_subnet" "spokesubnet_delegated" {
  count                = length(var.subnets_with_delegation)
  name                 = var.subnets_with_delegation[count.index].name
  provider             = azurerm.src
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.spokevnet.name
  address_prefixes     = [cidrsubnet(local.base_cidr_block, try(var.subnets_with_delegation[count.index].newbits,var.newbits), var.subnets_with_delegation[count.index].number)]
  service_endpoints    = try(var.subnets_with_delegation[count.index].service_endpoints,var.service_endpoints)
  delegation {
      name = var.subnets_with_delegation[count.index].delegation.name
  
      service_delegation {
        name    = var.subnets_with_delegation[count.index].delegation.name
          actions = try(var.subnets_with_delegation[count.index].delegation.actions, ["Microsoft.Network/virtualNetworks/subnets/action"])
      }
    }
  lifecycle { ignore_changes = [private_endpoint_network_policies] }
} 

resource "azurerm_subnet_network_security_group_association" "spokesubnetnsg" {
  provider                  = azurerm.src
  count                     = length(var.subnets)
  subnet_id                 = azurerm_subnet.spokesubnet[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
