#!/bin/bash

if [[ ! -d "${1:-$(pwd)}" ]]; then
  echo "usage: [bash] format.sh [DIRECTORY]" 1>&2
  exit 1
fi

echo "Formatting Code..."
clang-format -i -style=file "${1:-$(pwd)}"/*.c
clang-format -i -style=file "${1:-$(pwd)}"/*.h
echo "Done"
exit 0
