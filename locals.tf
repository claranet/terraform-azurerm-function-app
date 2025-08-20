locals {
  is_plan_linux_flex = startswith(var.sku_name, "FC")
  # Unified function app output - replaces submodule selection logic
  function_output = try(
    one(azurerm_linux_function_app.main[*]),
    one(azurerm_windows_function_app.main[*]),
    one(azurerm_function_app_flex_consumption.main[*])
  )
}
