output "network_security_group_name" {
  value = "${azurerm_network_security_group.nsg.name}"
}

output "resource_group_name" {
  value = "${azurerm_resource_group.rg.name}"
}
