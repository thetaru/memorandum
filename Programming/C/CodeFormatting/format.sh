#!/bin/bash
set -eu

PWD=$(cd $(dirname $0);pwd)

if [ $# -gt 1 ]; then
  echo "Syntax error." 1>&2
  echo "usage: [bash] format.sh [DIRECTORY]" 1>&2
  exit 1
fi

if [ ! -d "${1:-${PWD}}" ]; then
  echo "First argument is not Directory." 1>&2
  echo "usage: [bash] format.sh [DIRECTORY]" 1>&2
  exit 1
fi

if [ ! -f "${1:-${PWD}}/.clang-format" ]; then
  echo ".clang-format file not found." 1>&2
  exit 1
fi

echo "Formatting Code..."
if ls "${1:-${PWD}}"/*.c > /dev/null 2>&1; then
  clang-format -i -style=file "${1:-${PWD}}"/*.c
fi

if ls "${1:-${PWD}}"/*.h > /dev/null 2>&1; then
  clang-format -i -style=file "${1:-${PWD}}"/*.h
fi
echo "Done"

exit 0
