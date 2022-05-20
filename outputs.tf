output "linux_function_app" {
  description = "Linux Function App output object if Linux is choosen. Please refer to `./modules/linux-function/README.md`"
  value       = try(module.linux_function["enabled"], null)
}

output "windows_function_app" {
  description = "Windows Function App output object if Windows is choosen. Please refer to `./modules/windows-function/README.md`"
  value       = try(module.windows_function["enabled"], null)
}
