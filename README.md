# Terraform Module: for Azure vnet with nsg

## Required Resources

- `Resource Group` exists or is created external to the module.
- `Provider` must be created external to the module.

## Usage

```terraform
variable "address" {
  default = "10.0.1.0/24"
}

variable "subnets" {
  default = []
}

variable "subnets_with_delegation" {
  default = []
}

variable "endpoints" {
  default = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault"]
}

variable "tags" {
  type = map
  default = {
    ENVIRONMENT      = "Dev"
  }
}

variable "subscriptionId {
default="12312312312-312-312-3-12"
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
  source                        = "github.com/ukho/tfmodule-azure-vnet-with-nsg?ref=0.10.0"
  providers = {
    azurerm.src = azurerm.alias
  }
  prefix                        = "Prefix"
  tags                          = "${var.tags}"
  resource_group                = azurerm_resource_group.gg
  address                       = "${var.address}"
  subnets                       = "${var.subnets}"
  subnets_with_delegation       = "${var.subnets_with_delegation}"
  newbits                       = "4"
  service_endpoints             = "${var.endpoints}"
}
```

if you arent woried about the version you use, latest can be retrieved by removing `?ref=x.y.z` from source path

## Example for subnets

subnets are created using an array expecting a `name` and a `number`, number should increment from 0.

It is also worth noting, the addition of newbits to the base address should not exceed /29. Azure has the habit of absorbing 5 ip addresses per subnet. so the smallest you could go it a range of 8 ips (/29). with a newbits of 4, this would imply a minimum base of /25 is needed.

Each subnet can set it's own newbits or use the global value, if no newbit property is found it will always default to 4.

```terraform
subnets = [{
  name = "subnet1-subnet"
  number = 0
},
{
  name = "subnet2-subnet"
  number = 1
  newbits = 1 #optional
}]
```

## Example for subnets with delegation

```terraform
subnets_with_delegation = [{
  name = "subnet3-subnet"
  number = 2
  delegation = {
    name    = "Microsoft.Web/serverFarms"
    actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
}]
```

N.B. because `subnet` and `subnet_with_delegation` handle blank arrays you can mix and match

## Service Endpoints

An example of `service_endpoints` is ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault"]
