#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"
./prepare.sh

got="/tmp/got"
../inter-git-diff.sh "$LEFT_REPO" "$RIGHT_REPO" > "$got"

want="/tmp/want"
touch "$want"

diff "$want" "$got"
