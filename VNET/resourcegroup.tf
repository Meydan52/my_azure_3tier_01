resource "azurerm_resource_group" "resource_grp" {
  name   = var.rgrp_name
  region = var.region
}