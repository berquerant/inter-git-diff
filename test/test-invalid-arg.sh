#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"
"${thisd}/prepare.sh"

want="$(mktemp)"
echo "inter-git-diff.sh LEFT_REPO RIGHT_REPO" > "$want"
got="$(mktemp)"

run() {
    echo "Run invalid($1, $2)"
    ! "${thisd}/../inter-git-diff.sh" "$1" "$2" > "$got"
    diff "$want" "$got"
    cd "$LEFT_REPO"
    [ "$(git diff)" = "" ]
    cd "$RIGHT_REPO"
    [ "$(git diff)" = "" ]
}

not_exist_repo="/not/exist"

run "" ""
run "$not_exist_repo" ""
run "$LEFT_REPO" ""
run "$LEFT_REPO" "$not_exist_repo"
run "$not_exist_repo" "$RIGHT_REPO"
