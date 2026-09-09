# Flex Consumption apps run the package stored in their deployment container. Azure
# deprecated `WEBSITE_RUN_FROM_PACKAGE` on this plan and the provider's `zip_deploy_file`
# only uploads a local file, so a remote package is published with the `onedeploy`
# extension, which is the mechanism Azure documents and the only one following the HTTP
# redirects release URLs usually rely on.
#
# The call is shelled out because ARM answers it with a JSON body followed by an HTML
# error page, which makes the AzAPI provider fail even though the package is deployed.
resource "terraform_data" "flex_remote_package" {
  count = local.flex_remote_package_deploy ? 1 : 0

  triggers_replace = {
    function_app_id = one(azurerm_function_app_flex_consumption.main[*].id)
    package_uri     = var.application_zip_package_path
    remote_build    = var.application_package_remote_build
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/files/flex_onedeploy.sh"

    environment = {
      SUBSCRIPTION    = data.azurerm_subscription.current.subscription_id
      FUNCTION_APP_ID = one(azurerm_function_app_flex_consumption.main[*].id)
      PACKAGE_URI     = var.application_zip_package_path
      REMOTE_BUILD    = tostring(var.application_package_remote_build)
    }
  }
}
