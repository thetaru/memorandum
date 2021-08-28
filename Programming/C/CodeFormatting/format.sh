#!/bin/bash
set -eu

if [ $# -gt 1 ]; then
  echo "Syntax error." 1>&2
  echo "usage: [bash] format.sh [DIRECTORY]" 1>&2
  echo "" 1>&2
  exit 1
fi

if [ ! -d "${1:-$(pwd)}" ]; then
  echo "First argument is not Directory." 1>&2
  echo "usage: [bash] format.sh [DIRECTORY]" 1>&2
  exit 1
fi

echo "Formatting Code..."
clang-format -i -style=file "${1:-$(pwd)}"/*.c
clang-format -i -style=file "${1:-$(pwd)}"/*.h
echo "Done"
exit 0
