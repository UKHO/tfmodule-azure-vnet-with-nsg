resource "azurerm_network_security_group" "nsg" {
  provider            = azurerm.src
  name                = "${var.prefix}-nsg"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  tags = var.tags
  lifecycle { ignore_changes = [tags] }
}