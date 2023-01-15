#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"
"${thisd}/prepare.sh"

got="$(mktemp)"
! "${thisd}/../inter-git-diff.sh" "$LEFT_REPO" "$RIGHT_REPO" > "$got"

want="$(mktemp)"
cat - > "$want" <<EOT
Diff /tmp/left/a.txt /tmp/right/a.txt
Not exist /tmp/right/aa.txt
Diff /tmp/left/d/b.txt /tmp/right/d/b.txt
Not exist /tmp/left/d/d.txt
EOT

diff "$want" "$got"

cd "$LEFT_REPO"
[ "$(git diff)" = "" ]
cd "$RIGHT_REPO"
[ "$(git diff)" = "" ]
