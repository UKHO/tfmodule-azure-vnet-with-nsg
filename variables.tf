variable "prefix" { 
  description = "Prefix added to the front of the nsg and vnet" 
}

variable "resource_group_name" {
  description = "name of resource group resources will be added to"
}

variable "address" {  
  description = "base address for subnets to be added"
}

variable "subnets" {    
  description = "array of subnets"
}

variable "newbits" {
  default = 4
}

variable "service_endpoints" {  
  default = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault"]
}

variable "tags" {
  type = map
  default = ""
}
