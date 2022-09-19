#!/bin/bash
ARCH=${ARCH:-"x86_64"}
# check platform
if [[ "$(uname)" == "Darwin" ]]; then
  PLATFORM="darwin"
elif [[ "$(uname)" == "Linux" ]]; then
  PLATFORM="linux"
else
  PLATFORM="windows"
fi
# get latest release binaries

# if jq not installed, exit
if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed.' >&2
  exit 1
fi

TAG=`curl -s https://api.github.com/repos/robertlestak/jds/releases/latest \
| jq -r '.tag_name'`

GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/robertlestak/jds"
GH_TAGS="$GH_REPO/releases/tags/$TAG"

# Read asset tags.
id=$(curl -s $GH_TAGS | jq '.assets[] | select(.name | (contains("'$PLATFORM'") and contains("'$ARCH'") and (contains("sha512")|not) ) ) | .id')
# Get ID of the asset based on given name.
[ "$id" ] || { echo "Error: Failed to get asset id, response: $response" | awk 'length($0)<100' >&2; exit 1; }
GH_ASSET="$GH_REPO/releases/assets/$id"

curl $CURL_ARGS -H 'Accept: application/octet-stream' "$GH_ASSET" -Lo jds

chmod +x jds
# check if jds is in path, if so, replace
if [[ "$(command -v jds)" ]]; then
  mv jds $(which jds)
else
  mv jds /usr/local/bin/jds
fi