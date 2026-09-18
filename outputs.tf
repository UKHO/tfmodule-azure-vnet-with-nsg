output "virtual_network_name" {
  value = azurerm_virtual_network.spokevnet.name
}

output "network_security_group_id" {
  value = azurerm_network_security_group.nsg.id
}

output "network_security_group_name" {
  value = azurerm_network_security_group.nsg.name
}

output "subnet_ids" {
  value = {
    for idx, subnet in azurerm_subnet.spokesubnet : subnet.name => subnet.id
  }
}