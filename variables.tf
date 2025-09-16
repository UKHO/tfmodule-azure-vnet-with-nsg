variable "prefix" { 
  description = "Prefix added to the front of the NSG and VNet" 
  type        = string
}

variable "resource_group" {
  description = "Resource group object resources will be added to"
  type = object({
    name     = string
    location = string
  })
}

variable "dns_servers" {
  description = "List of DNS server IP addresses"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "Array of subnets. Each subnet can optionally have delegation."
  type = list(object({
    name               = string
    number             = number
    delegation_name    = optional(string)
    delegation_actions = optional(list(string))
    newbits            = optional(number)
  }))
}

variable "newbits" {
  description = "Default newbits for subnetting if not overridden per subnet"
  type        = number
  default     = 4
}

variable "service_endpoints" {  
  description = "Service endpoints to associate with the subnets"
  type        = list(string)
  default     = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault"]
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(any)
  default     = {}
}

# IPAM integration
variable "ipam_pool_name" {
  description = "Name of the IPAM pool to allocate from."
  type        = string
}

variable "network_manager_id" {
  description = "The ID of the Network Manager that owns the IPAM pool."
  type        = string
}

variable "number_of_ip_addresses" {
  description = "Exact number of IP addresses to allocate to the VNet from the IPAM pool."
  type        = number
}


#variable "enable_outbound" {
#  type = bool
#  default = true
#}