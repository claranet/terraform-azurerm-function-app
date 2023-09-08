#!/bin/bash

set -e

eval "$(jq -r '@sh "SUBSCRIPTION=\(.subscription);WEBAPP_NAME=\(.webapp_name);RG_NAME=\(.rg_name)"')"

APP_SETTING_VALUE=$(az webapp config appsettings list --name "${WEBAPP_NAME}" --resource-group "${RG_NAME}" --subscription "${SUBSCRIPTION}" || echo "[]")

# List of ignored setting comes from https://github.com/hashicorp/terraform-provider-azurerm/blob/d0ae3bfc59c0587ac19ab41977c16458b9c11298/internal/services/appservice/linux_function_app_resource.go#L1227
echo "${APP_SETTING_VALUE}" | jq '[. | to_entries[] | select(.value.name| test("(FUNCTIONS_EXTENSION_VERSION|WEBSITE_NODE_DEFAULT_VERSION|WEBSITE_CONTENTAZUREFILECONNECTIONSTRING|WEBSITE_CONTENTSHARE|WEBSITE_HTTPLOGGING_RETENTION_DAYS|FUNCTIONS_WORKER_RUNTIME|DOCKER_REGISTRY_SERVER_URL|DOCKER_REGISTRY_SERVER_USERNAME|DOCKER_REGISTRY_SERVER_PASSWORD|APPINSIGHTS_INSTRUMENTATIONKEY|APPLICATIONINSIGHTS_CONNECTION_STRING|AzureWebJobsStorage|AzureWebJobsDashboard|WEBSITE_HEALTHCHECK_MAXPINGFAILURES|AzureWebJobsStorage__accountName|AzureWebJobsDashboard__accountName|WEBSITE_RUN_FROM_PACKAGE|WEBSITE_VNET_ROUTE_ALL)")| not) | {"key": .value.name, "value": .value.value}] | from_entries'
