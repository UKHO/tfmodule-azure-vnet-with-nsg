data "azurerm_network_manager_ipam_pool" "selected" {
  name               = var.ipam_pool_name
  network_manager_id = var.network_manager_id
}
  
resource "azurerm_virtual_network" "spokevnet" {
  name                = "${var.prefix}-vnet"
  provider            = azurerm.src
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  dns_servers         = var.dns_servers
  tags                = var.tags

  ip_address_pool {
  id                     = data.azurerm_network_manager_ipam_pool.selected.id
  number_of_ip_addresses = var.number_of_ip_addresses 
}

  lifecycle {
    ignore_changes = [tags]
  }
}