#!/bin/bash

OUTPUT="/etc/squid/blacklists/common"
LOGFILE="/var/log/squid/UrlHealthCheck.log"

URLS=()
URLS+=("https://adaway.org/hosts.txt")
URLS+=("http://winhelp2002.mvps.org/hosts.txt")
URLS+=("https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext")
URLS+=("https://raw.githubusercontent.com/multiverse2011/adawaylist-jp/master/hosts")
URLS+=("https://warui.intaa.net/adhosts/hosts.txt")
URLS+=("https://raw.githubusercontent.com/Ewpratten/youtube_ad_blocklist/master/blocklist.txt")

for URL in "${URLS[@]}"; do
  # GET HTTP STATUS
  HTTP_STATUS=$(curl -LI "$URL" -o /dev/null -w '%{http_code}\n' -s)

  if [ -f "${OUTPUT}" ]; then
    cp -p "${OUTPUT}" "${OUTPUT}.$(date +%Y%m%d)"
    rm -f "${OUTPUT}"
  fi

  # GET BLACKLIST
  if [ "$HTTP_STATUS" -eq "200" ]; then
    curl -sfL "$URL" | \
         grep -v \
              -e localhost \
              -e ^\# \
              -e ^$ | \
         sed  -e 's/^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}//g' \
              -e 's/^ *\| *$//' >> "${OUTPUT}"
  else
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: Failed to access url ${URL}" >> "${LOGFILE}"
  fi
done

sort -u "${OUTPUT}" -o "${OUTPUT}"
