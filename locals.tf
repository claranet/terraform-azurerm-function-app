locals {
  function_output    = try(module.linux_function[0], module.windows_function[0], module.flex_function[0])
  is_plan_linux_flex = startswith(var.sku_name, "FC")
}
