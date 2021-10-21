# Terraform Module: for Azure vnet with nsg

## Required Resources

- `Resource Group` exists or is created external to the module.
- `Provider` must be created external to the module.

## Usage

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
  default = []
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

provider "azurerm" {
  version = "=2.20.0"
  features {}
  alias           = "alias"
  subscription_id = var.SubscriptionId
}


resource "azurerm_resource_group" "gg" {
  name = "existing-rg"
  location = "UKSouth"
  tags = var.tags
}

module "setup" {
  source                        = "github.com/ukho/tfmodule-azure-vnet-with-nsg?ref=0.8.1"
  providers = {
    azurerm.src = azurerm.alias
  }
  resource_group              = azurerm_resource_group.rg
  tags                        = var.TAGS
  prefix                      = var.ProjectIdentity
  address                     = var.MAIN_ADDRESS
  dns_servers                 = var.DNS_SERVERS
  subnets                     = var.SUBNETS
  newbits                     = var.NEWBITS
  service_endpoints           = var.MAIN_ENDPOINTS
}
```

if you arent woried about the version you use, latest can be retrieved by removing `?ref=x.y.z` from source path

## Example for subnets

subnets are created using an array expecting a `name` and a `number`, number should increment from 0.

It is also worth noting, the addition of newbits to the base address should not exceed /29. Azure has the habit of absorbing 5 ip addresses per subnet. so the smallest you could go it a range of 8 ips (/29). with a newbits of 4, this would imply a minimum base of /25 is needed.

```terraform
[{
  name = "subnet1-subnet"
  number = 0
},
{
  name = "subnet2-subnet"
  number = 1
}]
```
## Example for subnets with delegation

In the instances where you want to delegate a specific subnet the addition of a deletagation value will allow for this setting.

In this example we are assigning the first subnet to be used for a serverfarm.

```terraform
[{
  name = "subnet1-subnet"
  number = 0
  delegation = {
    name = "Microsoft.Web/serverFarms"
    actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
  }
},
{
  name = "subnet2-subnet"
  number = 1
}]
```

## Service Endpoints

An example of `service_endpoints` is ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault"]
