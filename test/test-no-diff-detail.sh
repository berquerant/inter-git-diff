#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"
"${thisd}/prepare.sh"

got="$(mktemp)"
IGD_DIFF_DETAIL=1 "${thisd}/../inter-git-diff.sh" "$LEFT_REPO" "$LEFT_REPO" > "$got"

want="$(mktemp)"
cat - > "$want" <<EOT
Check /tmp/left/README.md and /tmp/left/README.md
Check /tmp/left/a.txt and /tmp/left/a.txt
Check /tmp/left/aa.txt and /tmp/left/aa.txt
Check /tmp/left/d/b.txt and /tmp/left/d/b.txt
Check /tmp/left/d/c.txt and /tmp/left/d/c.txt
Check /tmp/left/d/e.txt and /tmp/left/d/e.txt
EOT

diff "$want" "$got"

cd "$LEFT_REPO"
[ "$(git diff)" = "" ]
cd "$RIGHT_REPO"
[ "$(git diff)" = "" ]
