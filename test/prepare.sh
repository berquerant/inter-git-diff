#!/bin/bash

set -ex

thisd="$(cd $(dirname $0); pwd)"

rm -rf "$LEFT_REPO" "$RIGHT_REPO"
cp -r "${thisd}/left" "$LEFT_REPO"
cp -r "${thisd}/right" "$RIGHT_REPO"

git config --global user.email "test@example.com"
git config --global user.name "test"
git config --global init.defaultBranch "main"

init_repo() {
    cd "$1"
    git init
    git add -A
    git commit -m 'Initial commit'
}

init_repo "$LEFT_REPO"
init_repo "$RIGHT_REPO"
