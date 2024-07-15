resource "azurerm_subnet" "spokesubnet" {
  count                = length(var.subnets)
  name                 = var.subnets[count.index].name
  provider             = azurerm.src
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.spokevnet.name
  address_prefixes     = [cidrsubnet(local.base_cidr_block, try(var.subnets[count.index].newbits,var.newbits), var.subnets[count.index].number)]
  service_endpoints    = var.service_endpoints
  lifecycle { ignore_changes = [delegation] }
} 

resource "azurerm_subnet_network_security_group_association" "spokesubnetnsg" {
  provider                  = azurerm.src
  count                     = length(var.subnets)
  subnet_id                 = azurerm_subnet.spokesubnet[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
