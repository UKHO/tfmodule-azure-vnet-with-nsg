resource "azurerm_network_security_rule" "deny" { 
  provider                    = azurerm.src
  name                        = "DenyInternetOutbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = var.resource_group.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
