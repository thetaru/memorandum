#!/bin/bash
set -euo pipefail

function get_ip_list() {
  local readonly URL="https://endpoints.office.com/endpoints/worldwide?clientrequestid=b10c5ed1-bad1-445f-b386-b919946339a7"
  local IP_LIST=$(curl -s "${URL}" | jq -r \
  '.[] | select(.serviceAreaDisplayName == "Microsoft 365 Common and Office Online") | select(.ips != null) | .ips[]' | grep -v ":" | sort -u)
  echo ${IP_LIST}
}

function main() {
  cd "$(dirname "$0")"
  local ips=$(get_ip_list)
  for ip in ${ips}; do
    echo "${ip}"
  done
}

main
