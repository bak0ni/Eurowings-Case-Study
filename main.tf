provider "azurerm" {
  version = "=2.8.0"
  features {}
}


resource "azurerm_resource_group" "ewcasestudy" {
    name = var.resource_group_name
    location = var.location
}

#Create virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-ewapim-${var.location}-001"
    address_space       = var.vnet_address_space
    location            = var.location
    resource_group_name = var.resource_group_name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "snet-apim-${var.location}-001 "
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.0.0.0/24"
}

# Create network security group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-apim-001 "
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "APIM"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_api_management" "apim" {
    location                  = var.location
    name                      = var.apim_name 
    publisher_email           = var.publisher_email
    publisher_name            = var.publisher_name
    resource_group_name       = var.resource_group_name
    sku_name                  = var.sku_name 
    tags                      = var.tags
    virtual_network_type      = "Internal"
    

    virtual_network_configuration {
      subnet_id = azurerm_subnet.subnet.id
  }


  identity {
        type         =   "SystemAssigned"
    }

    protocols {
        enable_http2 = false
    }

    sign_up {
        enabled = false

        terms_of_service {
            consent_required = false
            enabled          = false
        }
    }
    

    lifecycle {
      ignore_changes = [hostname_configuration]
    }
}

resource "azurerm_app_service_plan" "ewCaseStudy" {
    name                = "ewServicePlan"
    location            = var.location
    resource_group_name = var.resource_group_name
    sku {
        tier = "Standard"
        size = "S1"
    }
}

resource "azurerm_app_service" "ewCaseStudy" {
    name                = "Staging"
    location            = var.location
    resource_group_name = var.resource_group_name
    app_service_plan_id = azurerm_app_service_plan.ewCaseStudy.id
}

resource "azurerm_app_service_slot" "ewCaseStudy" {
    name                = "Production"
    location            = var.location
    resource_group_name = var.resource_group_name
    app_service_plan_id = azurerm_app_service_plan.ewCaseStudy.id
    app_service_name    = azurerm_app_service.ewCaseStudy.name
}
