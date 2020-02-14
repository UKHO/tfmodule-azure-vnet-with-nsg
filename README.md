# Terraform Module: for Azure vnet with nsg

## Caveat

- `Resource Group` exists or is created external to the module.

## Useage

resource "azurerm_resource_group" "gg" {
  name = "resourcegroup-rg"
  location = "UKSouth"
}

module "setup" {
  source                        = "github.com/ukho/tfmodule-azure-vnet-with-nsg?ref=1.0.0"
  prefix                        = "[Put in front of vnet and nsg]"
  Tags                          = "[Required Tags]"
  resource_group_name           = azurerm_resource_group.gg.name 
  address                       = "[IPBase]" 
  subnets                       = "[SubnetMap]"
  newbits                       = "4"
  service_endpoints             = "[AnyDesiredEndpoints]"
}

if you arent woried about the version you use, latest can be retrieved by removing `?ref=x.y.z` from source path

## Example for subnets

subnets are created using an array expecting a `name` and a `number`, number should increment from 0.

It is also worth noting, the addition of newbits to the base address should not exceed /29. Azure has the habit of absorbing 5 ip addresses per subnet. so the smallest you could go it a range of 8 ips (/29). with a newbits of 4, this would imply a minimum base of /25 is needed.

```
[{
  name = "subnet1-subnet"
  number = 0
},
{
  name = "subnet2-subnet"
  number = 1
}] 
```

## Service Endpoints

An example of `service_endpoints` is ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault"]
