locals {
  function_output = try(module.linux_function["enabled"], module.windows_function["enabled"])
}