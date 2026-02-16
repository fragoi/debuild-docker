#!/bin/bash -e

. archive.sh

prepare archive dir

echo "Changing directory ${dir}"
cd "$dir"

echo "Run debsign"
debsign "$@"
