#!/bin/bash

set -e

eval "$(jq -r '@sh "SUBSCRIPTION=\(.subscription);WEBAPP_NAME=\(.webapp_name);RG_NAME=\(.rg_name)"')"

APP_SETTING_VALUE=$(az webapp config appsettings list --name "${WEBAPP_NAME}" --resource-group "${RG_NAME}" --subscription "${SUBSCRIPTION}" || echo "[]")

echo "${APP_SETTING_VALUE}" | jq '[. | to_entries[] | select(.value.name| test("(APPINSIGHTS_INSTRUMENTATIONKEY|APPLICATIONINSIGHTS_CONNECTION_STRING|AzureWebJobsDashboard|AzureWebJobsStorage|FUNCTIONS_EXTENSION_VERSION|WEBSITE_VNET_ROUTE_ALL)")| not) | {"key": .value.name, "value": .value.value}] | from_entries'
