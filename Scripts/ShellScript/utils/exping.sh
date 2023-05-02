#!/bin/bash
set -euo pipefail

function usage()
{
  cat <<- EOS
    Description:
      $(basename $0) is tool to ping multiple terminals.
    Usage:
      $(basename $0) [device]
    Example:
      $(basename $0) eth0
EOS
}

# IPアドレス表記 -> 32bit値 に変換
function ip2decimal()
{
  local IFS=.
  local c=($1)
  printf "%s\n" $(( (${c[0]} << 24) | (${c[1]} << 16) | (${c[2]} << 8) | ${c[3]} ))
}

# 32bit値 -> IPアドレス表記 に変換
function decimal2ip()
{
  local n="$1"
  printf "%d.%d.%d.%d\n" $(($n >> 24)) $(( ($n >> 16) & 0xFF)) $(( ($n >> 8) & 0xFF)) $(($n & 0xFF))
}

# CIDR 表記のネットワークアドレスを 32bit値に変換
function cidr2decimal()
{
  printf "%s\n" $(( 0xFFFFFFFF ^ ((2 ** (32-$1))-1) ))
}

# IPアドレス一覧に対して疎通確認を行う
function exping()
{
  local iplist=()
  local num=$(ip2decimal "$1")
  local max=$(("${num}" + "$2" - 1))

  # 連続したIPアドレスの配列を作る
  while true; do
    iplist+=($(decimal2ip "${num}"))
    [[ ${num} == ${max} ]] && break || num=$((${num}+1))
  done

  printf "%s\n" "${iplist[@]}" | xargs -P 254 -I{} sh -c 'ping -s1 -c1 -W0.5 "{}" &> /dev/null && echo "{}"' | sort 
}

# 引数のチェック
if [ $# == 1 ] && [ "$1" != "" ]; then
  DEVICE_NAME="$1"
else
  usage
  exit 1
fi

IP_CIDR=$(nmcli -g ip4.address device show "${DEVICE_NAME}")
IP="$( echo "${IP_CIDR}" | cut -d '/' -f1 | awk '{ print $1 }' )"
CIDR="$( echo "${IP_CIDR}" | cut -d '/' -f2 | awk '{ print $1 }' )"
NW_ADDR="$( decimal2ip $(( $(ip2decimal "${IP}") & $(cidr2decimal "${CIDR}") )))"
exping ${NW_ADDR} $((2 ** (32-${CIDR})))
