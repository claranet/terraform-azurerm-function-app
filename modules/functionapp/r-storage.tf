resource "azurerm_storage_account" "storage" {
  name = local.storage_account_name

  location            = var.location
  resource_group_name = var.resource_group_name

  account_replication_type = "LRS"
  account_tier             = "Standard"
  account_kind             = var.storage_account_kind
  min_tls_version          = var.storage_account_min_tls_version

  enable_https_traffic_only = var.storage_account_enable_https_traffic_only

  dynamic "identity" {
    for_each = var.storage_account_identity_type == null ? [] : [1]
    content {
      type         = var.storage_account_identity_type
      identity_ids = var.storage_account_identity_ids == "UserAssigned" ? var.storage_account_identity_ids : null
    }
  }

  tags = merge(
    local.default_tags,
    var.storage_account_extra_tags,
    var.extra_tags,
  )

  count = var.storage_account_access_key == null ? 1 : 0
}

resource "azurerm_storage_account_network_rules" "storage_network_rules" {
  for_each = toset(var.storage_account_access_key == null && (var.authorized_ips != null || var.authorized_subnet_ids != null) ? ["enabled"] : [])

  resource_group_name  = var.resource_group_name
  storage_account_name = azurerm_storage_account.storage[0].name

  default_action             = "Deny"
  ip_rules                   = local.storage_ips
  virtual_network_subnet_ids = var.authorized_subnet_ids
  bypass                     = var.storage_account_network_bypass
}

resource "azurerm_advanced_threat_protection" "threat_protection" {
  count = var.storage_account_access_key == null ? 1 : 0

  enabled            = var.storage_account_enable_advanced_threat_protection
  target_resource_id = azurerm_storage_account.storage[0].id
}

data "azurerm_storage_account" "storage" {
  name                = local.storage_account_name
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_storage_account.storage]
}

resource "azurerm_storage_container" "package_container" {
  count = var.application_zip_package_path != null && local.is_local_zip ? 1 : 0

  name                  = "functions-packages"
  storage_account_name  = data.azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "package_blob" {
  count = var.application_zip_package_path != null && local.is_local_zip ? 1 : 0

  name                   = "${local.function_app_name}.zip"
  storage_account_name   = azurerm_storage_container.package_container[0].storage_account_name
  storage_container_name = azurerm_storage_container.package_container[0].name
  type                   = "Block"
  source                 = var.application_zip_package_path
  content_md5            = filemd5(var.application_zip_package_path)
}

data "azurerm_storage_account_sas" "package_sas" {
  connection_string = data.azurerm_storage_account.storage.primary_connection_string
  https_only        = false
  resource_types {
    service   = false
    container = false
    object    = true
  }
  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }
  start  = "2021-01-01"
  expiry = "2041-01-01"
  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
  }
}
