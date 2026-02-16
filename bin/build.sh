#!/bin/bash -e

. archive.sh

prepare archive dir

echo "Changing directory ${dir}"
cd "$dir"

echo "Installing dependencies"
install-deps.sh "debian/control"
install-deps.sh "debian/control" "-Arch"
install-deps.sh "debian/control" "-Indep"

echo "Run debuild"
debuild "$@"
