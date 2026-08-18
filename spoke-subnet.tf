resource "azurerm_subnet" "spokesubnet" {
  for_each             = { for s in var.subnets : s.name => s }
  name                 = each.value.name
  provider             = azurerm.src
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.spokevnet.name
  address_prefixes     = [cidrsubnet(local.base_cidr_block,coalesce(each.value.newbits, var.newbits),each.value.number)]
  default_outbound_access_enabled = var.enable_outbound
  
  dynamic "service_endpoint" {
    for_each = var.service_endpoints
    content {
      service            = service_endpoint.value.service
      network_identifier = service_endpoint.value.network_identifier
    }
  }
  
  dynamic "delegation" {
    for_each = each.value.delegation_name != null ? [1] : []
    content {
      name = "delegation"
      service_delegation {
        name    = each.value.delegation_name
        actions = each.value.delegation_actions
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "spokesubnetnsg" {
  provider                  = azurerm.src
  for_each                  = azurerm_subnet.spokesubnet
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.nsg.id
} 