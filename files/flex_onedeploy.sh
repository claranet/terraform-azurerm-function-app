#!/bin/bash

set -euo pipefail

# Deploys an application package to a Flex Consumption Function App through the
# `onedeploy` extension. That extension is the mechanism Azure documents for this
# plan and the only one able to fetch a *remote* package: `zip_deploy_file` uploads
# a local file only, `WEBSITE_RUN_FROM_PACKAGE` is deprecated on Flex Consumption,
# and the storage copy-blob API rejects the HTTP redirects release URLs rely on.
#
# The call is made from here rather than with an `azapi_resource` because ARM answers
# it with a JSON body followed by an HTML error page: strict clients such as the AzAPI
# provider fail on the malformed payload even though the package is deployed.

api_version="2022-09-01"
base_url="https://management.azure.com${FUNCTION_APP_ID}"
poll_timeout="${DEPLOY_TIMEOUT:-600}"
poll_interval=10

# Flattens the response and drops the trailing HTML so that `jq` can read the JSON.
arm_request() {
  az rest --method "$1" --subscription "${SUBSCRIPTION}" --url "$2" "${@:3}" 2>/dev/null |
    tr '\n' ' ' | sed 's/<!DOCTYPE.*//'
}

request_body="$(jq -n --arg uri "${PACKAGE_URI}" --argjson remote "${REMOTE_BUILD}" \
  '{properties: {packageUri: $uri, remoteBuild: $remote}}')"

deployment_id="$(
  arm_request put "${base_url}/extensions/onedeploy?api-version=${api_version}" \
    --headers "Content-Type=application/json" --body "${request_body}" |
    jq -r '.properties.deployment.id // empty'
)"

if [ -z "${deployment_id}" ]; then
  echo "onedeploy did not return a deployment id for ${PACKAGE_URI}." >&2
  exit 1
fi

# ARM reports the call as successful even when the package cannot be downloaded, so the
# deployment is polled until it completes. Status 4 is a success, 3 a failure and 5 a
# conflict with a concurrent deployment.
elapsed=0
while true; do
  deployment="$(
    arm_request get "${base_url}/deployments?api-version=${api_version}" |
      jq -c --arg id "${deployment_id}" 'first(.value[] | select(.properties.id == $id)) // empty'
  )"

  if [ -n "${deployment}" ] && [ "$(jq -r '.properties.complete' <<<"${deployment}")" = "true" ]; then
    break
  fi

  if [ "${elapsed}" -ge "${poll_timeout}" ]; then
    echo "onedeploy of ${PACKAGE_URI} did not complete within ${poll_timeout}s (deployment ${deployment_id})." >&2
    exit 1
  fi

  sleep "${poll_interval}"
  elapsed=$((elapsed + poll_interval))
done

status="$(jq -r '.properties.status' <<<"${deployment}")"

if [ "${status}" != "4" ]; then
  echo "onedeploy of ${PACKAGE_URI} failed with status ${status}: $(jq -r '.properties.status_text // "no detail reported"' <<<"${deployment}")" >&2
  exit 1
fi
