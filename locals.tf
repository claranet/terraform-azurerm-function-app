locals {
  function_output = try(module.linux_function[0], module.windows_function[0], module.flex_function[0])
}
