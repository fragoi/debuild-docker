#!/bin/bash -e

## When there is more than one distribution specified in changelog,
## run the command once for each distribution,
## adapting the changelog for that specific distribution.

. archive.sh

modifyChangelog() {
  local version=$1
  local dist=$2
  sed -e "1s/(.*) .*;/(${version}) ${dist};/" \
    -i "$changelog"
}

cmd=$1

[[ "$cmd" ]] || {
  echo >&2 "Usage: $0 <cmd> [<arg>...]"
  exit 2
}

shift

prepare archive dir

## propagate resolved archive for command
export DEBUILD_ARCHIVE=$archive

changelog="${dir}/debian/changelog"

echo "Checking distribution"
dists=($(dpkg-parsechangelog -l "$changelog" -S Distribution))
echo "Distributions: ${dists[*]}"

## if we have only one dist, just run command and exit
if [[ ${#dists[@]} = 1 ]]; then
  echo "Running command for distribution: ${dists}"
  $cmd "$@"
  exit
fi

version=$(dpkg-parsechangelog -l "$changelog" -S Version)
for (( i = 0; i < ${#dists[@]}; i++ )); do
  dist=${dists[i]}
  echo "Adapting changelog for: ${dist}"
  modifyChangelog "${version}~${i}${dist}" "${dist}"
  echo "Running command for distribution: ${dist}"
  $cmd "$@"
done

echo "Reset changelog"
modifyChangelog "${version}" "${dists[*]}"
