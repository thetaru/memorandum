#!/bin/bash
set -euo pipefail

function get_ip_list() {
  # Office 365 URL および IP アドレス範囲
  # https://docs.microsoft.com/ja-jp/microsoft-365/enterprise/urls-and-ip-address-ranges?view=o365-worldwide
  local readonly URL="https://endpoints.office.com/endpoints/worldwide?clientrequestid=b10c5ed1-bad1-445f-b386-b919946339a7"
  # IPv6正規表現
  # https://stackoverflow.com/questions/53497/regular-expression-that-matches-valid-ipv6-addresses
  local IPv6_REGEX="(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))"
  local IP_LIST=$(curl -s "${URL}" | jq -r \
    '.[] | select(.serviceAreaDisplayName == "Microsoft 365 Common and Office Online") | select(.ips != null) | .ips[]' | \
    grep -E -v "${IPv6_REGEX}" | \
    sort -u)
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
