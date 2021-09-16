terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

locals {
    rg_prefix = "rg-${var.product_name}-${var.environment}"
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_prefix
  location = "West Europe"
}

resource "azurerm_app_service_plan" "sp" {
  name                = "${local.rg_prefix}-free-tier"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Free"
    size = "F1"
  }
}

module "notifications-service" {
  source = "../modules/custom-app-service/"
  service_name = "notifications"
  resource_group = { 
    location = azurerm_resource_group.rg.location
    name = azurerm_resource_group.rg.name
  }
  environment = var.environment
  app_service_plan_id = azurerm_app_service_plan.sp.id
}


module "payments-service" {
  source = "../modules/custom-app-service/"
  service_name = "payments-changed"
  resource_group = { 
    location = azurerm_resource_group.rg.location
    name = azurerm_resource_group.rg.name
  }
  environment = var.environment
  app_service_plan_id = azurerm_app_service_plan.sp.id
}
