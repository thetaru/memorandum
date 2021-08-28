#!/bin/bash

if [[ $# -ne 1 ]]; then
  echo "usage: format.sh DIRECTORY" 1>&2
  return 1
fi

if [[ ! -d "$1" ]]; then
  echo "usage: format.sh DIRECTORY" 1>&2
  return 1
fi

echo "Formatting Code..."
clang-format -i -style=file "$1"/*.c
clang-format -i -style=file "$1"/*.h
echo "Done"
exit 0
