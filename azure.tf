locals {
  base_cidr_block = var.address
}

provider "azurerm" {
  alias = "src"
}