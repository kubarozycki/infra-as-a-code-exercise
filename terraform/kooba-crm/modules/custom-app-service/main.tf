
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}


resource "random_uuid" "rnd" {
}

resource "azurerm_app_service" "terraform-sample" {
  name                = "${var.service_name}-${var.environment}-${random_uuid.rnd.result}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  app_service_plan_id = var.app_service_plan_id
}
