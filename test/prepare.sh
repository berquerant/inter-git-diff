#!/bin/bash

set -ex

thisd="$(cd $(dirname $0); pwd)"

export LEFT_REPO="/tmp/left"
export RIGHT_REPO="/tmp/right"

rm -rf "$LEFT_REPO" "$RIGHT_REPO"
cp -r "${thisd}/left" "$LEFT_REPO"
cp -r "${thisd}/right" "$RIGHT_REPO"

init_repo() {
    cd "$1"
    git init
    git add -A
    git commit -m 'Initial commit'
}

init_repo "$LEFT_REPO"
init_repo "$RIGHT_REPO"
