output "resource_group_name" {
  value = "${azurerm_resource_group.rg.name}"
}

output "location" {
  value = "${azurerm_resource_group.rg.location}"
}

output "network_security_group_name" {
  value = "${azurerm_network_security_group.nsg.name}"
}
