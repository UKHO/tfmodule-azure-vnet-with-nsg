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

variable "dns_servers" {
  description = "ips for dns server"
}


variable "subnets" {
  description = "Array of subnets. Each subnet can optionally have delegation."
  type = list(object({
    name               = string
    number             = number
    delegation_name    = optional(string)
    delegation_actions = optional(list(string))
  }))
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

variable "enable_outbound" {
  type = bool
  default = true
}