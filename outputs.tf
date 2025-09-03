output "virtual_network_name" {
  value = azurerm_virtual_network.spokevnet.name
}

output "network_security_group_id" {
  value = azurerm_network_security_group.nsg.id
}

output "network_security_group_name" {
  value = azurerm_network_security_group.nsg.name
}

output "virtual_network_id" {
  value = azurerm_virtual_network.spokevnet.id
}

output "subnet_ids" {
  value = { for name, subnet in azurerm_subnet.spokesubnet : name => subnet.id }
}
