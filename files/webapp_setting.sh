#!/bin/bash

set -e

eval "$(jq -r '@sh "SUBSCRIPTION=\(.subscription);WEBAPP_NAME=\(.webapp_name);RG_NAME=\(.rg_name)"')"

APP_SETTING_VALUE=$(az webapp config appsettings list --name "${WEBAPP_NAME}" --resource-group "${RG_NAME}" --subscription "${SUBSCRIPTION}" || echo "[]")

[ -z "$APP_SETTING_VALUE" ] && APP_SETTING_VALUE="[]"

# App settings to be ignored (seemingly) is here https://github.com/hashicorp/terraform-provider-azurerm/blob/a543b5ca1003e06bff74c44158816e2134d79008/internal/services/appservice/linux_function_app_data_source.go#L436

echo "${APP_SETTING_VALUE}" | jq '[. | to_entries[] | select(.value.name| test("(APPINSIGHTS_INSTRUMENTATIONKEY|APPLICATIONINSIGHTS_CONNECTION_STRING|WEBSITE_CONTENTSHARE|WEBSITE_CONTENTAZUREFILECONNECTIONSTRING|FUNCTIONS_WORKER_RUNTIME|AzureWebJobsDashboard|AzureWebJobsStorage|FUNCTIONS_EXTENSION_VERSION|WEBSITE_VNET_ROUTE_ALL)")| not) | {"key": .value.name, "value": .value.value}] | from_entries'
