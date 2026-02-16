#!/bin/bash -e

## Creates a debian source package from source archives.

. archive.sh

prepare archive dir

echo "Changing directory ${dir}"
cd "$dir"

echo "Run dpkg-source"
dpkg-source -b . $SOURCE_OPTS

echo "Read package info"
name=$(dpkg-parsechangelog -S Source)
version=$(dpkg-parsechangelog -S Version)

#dpkg-genbuildinfo --build=source -O"../${name}_${version}_source.buildinfo"

echo "Generate changes"
dpkg-genchanges --build=source -O"../${name}_${version}_source.changes" $GENCHANGES_OPTS
