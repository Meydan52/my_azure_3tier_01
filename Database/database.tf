
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_mysql_server" "db_server" {
  name                = "${var.prefix}-mysqlserver"
  location            = azurerm_resource_group.rgrp.location
  resource_group_name = azurerm_resource_group.rgrp.name
  depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_subnet.private
  ]
  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "create_database" {
  name                = "myDB"
  resource_group_name = azurerm_resource_group.rgrp.name
  server_name         = azurerm_mysql_server.db_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_virtual_network_rule" "database_subnet" {
  name                = "mysql-vnet-rule"
  resource_group_name = azurerm_resource_group.rgrp.name
  server_name         = azurerm_mysql_server.db_server.name
  subnet_id           = azurerm_subnet.private.id
}