#!/bin/bash
set -euo pipefail

# @description: generate regex url(domain) from url
# @param url
# @return void
function generate_regex_url() {
  local URL="$1"
  ## STEP1: 文頭(http://|https://)削除
  ## STEP2: ディレクトリ部削除
  ## STEP3: .を\.に置換
  ## STEP4: トリム(不要な半角・全角スペースとタブを削除する)
  ## STEP5: 先頭の文字が*(アスタリスク)なら削除し、そうでない場合は^(ハット)を追加(2分割)
  ## STEP6: 先頭以外の*(アスタリスク)(STEP5で先頭にはない想定)を.*に置換
  ## STEP7: 末尾に$を追加
  echo ${URL} | sed -r \
    -e "s/^(http|https):\/\///" \
    -e "s|^([^/]*)/.*|\1|g" \
    -e "s/\./\\\./g" \
    -e "s/[ 　\t]//g" \
    -e "s/^([^\*].*)/^\1/" \
    -e "s/^\*(.*)/\1/" \
    -e "s/\*/\.\*/" \
    -e "s/(.*)/\1$/"
}

# @description: get url from json file
# @param
# @return
function get_url_list() {
  # Office 365 URL および IP アドレス範囲
  # https://docs.microsoft.com/ja-jp/microsoft-365/enterprise/urls-and-ip-address-ranges?view=o365-worldwide
  local readonly URL="https://endpoints.office.com/endpoints/worldwide?clientrequestid=b10c5ed1-bad1-445f-b386-b919946339a7"
  local URL_LIST=$(curl -s ${URL} | jq -r '.[] | select(.serviceAreaDisplayName == "Microsoft 365 Common and Office Online") | select(.urls != null) |.urls[]' | sort -u)
  echo ${URL_LIST}
}

function main() {
  cd "$(dirname "$0")"
  local urls=$(get_url_list)
  for url in ${urls}; do
    generate_regex_url "${url}"
  done
}

main
