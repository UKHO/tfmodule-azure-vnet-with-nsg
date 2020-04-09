variable "prefix" { 
  description = "Prefix added to the front of the nsg and vnet" 
}

variable "resource_group" {
  description = "resource group object resources will be added to"
  type = object({
    name         = string
    location     = string
  })
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
  default = {}
}
