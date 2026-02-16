#!/bin/bash -e

## Adapt the changelog for a specific distribution.

DEBDIST=${DEBDIST}
DEBDISTREV=${DEBDISTREV}

if [[ ! "$DEBDIST" ]]; then
  exit
fi

. archive.sh

prepare archive dir

echo "Changing directory ${dir}"
cd "$dir"

echo "Checking distribution"
dist=$(dpkg-parsechangelog -S Distribution)

if [[ "$dist" = "$DEBDIST" ]]; then
  echo >&2 "distribution already set"
  exit
fi

version=$(dpkg-parsechangelog -S Version)
version="${version}${DEBDISTREV:+~${DEBDISTREV}}"

echo "Setting distribution: ${DEBDIST}"
echo "Setting version: ${version}"

sed -e "1s/(.*) .*;/(${version}) ${DEBDIST};/" \
  -i debian/changelog
