#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"
"${thisd}/prepare.sh"

cd "${LEFT_REPO}"/..
got="$(mktemp)"
! "${thisd}/../inter-git-diff.sh" "left" "right" > "$got"

want="$(mktemp)"
cat - > "$want" <<EOT
Diff /tmp/left/a.txt /tmp/right/a.txt
Not exist /tmp/right/aa.txt
Diff /tmp/left/d/b.txt /tmp/right/d/b.txt
Not exist /tmp/left/d/d.txt
Not exist /tmp/right/d/e.txt
EOT

diff "$want" "$got"

cd "$LEFT_REPO"
[ "$(git diff)" = "" ]
cd "$RIGHT_REPO"
[ "$(git diff)" = "" ]
