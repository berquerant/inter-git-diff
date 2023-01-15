#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"
"${thisd}/prepare.sh"

got="$(mktemp)"
"${thisd}/../inter-git-diff.sh" "$LEFT_REPO" "$LEFT_REPO" > "$got"

want="$(mktemp)"

diff "$want" "$got"

cd "$LEFT_REPO"
[ "$(git diff)" = "" ]
cd "$RIGHT_REPO"
[ "$(git diff)" = "" ]
