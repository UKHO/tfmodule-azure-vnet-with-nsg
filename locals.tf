locals {
  base_cidr_block = var.address2 != null ? [var.address2] : [var.address, var.address2]
}
