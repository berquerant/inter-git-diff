#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"
"${thisd}/prepare.sh"

got="$(mktemp)"
! IGD_REPLACE=1 "${thisd}/../inter-git-diff.sh" "$LEFT_REPO" "$RIGHT_REPO" > "$got"

want="$(mktemp)"
cat - > "$want" <<EOT
Replace /tmp/right/a.txt with /tmp/left/a.txt
Copy /tmp/left/aa.txt to /tmp/right/aa.txt
Replace /tmp/right/d/b.txt with /tmp/left/d/b.txt
Remove /tmp/right/d/d.txt
Copy /tmp/left/d/e.txt to /tmp/right/d/e.txt
EOT

diff "$want" "$got"

cd "$LEFT_REPO"
[ "$(git diff)" = "" ]
cd "$RIGHT_REPO"
git add -A
diff "${LEFT_REPO}/a.txt" "${RIGHT_REPO}/a.txt"
diff "${LEFT_REPO}/aa.txt" "${RIGHT_REPO}/aa.txt"
diff "${LEFT_REPO}/d/b.txt" "${RIGHT_REPO}/d/b.txt"
diff "${LEFT_REPO}/d/c.txt" "${RIGHT_REPO}/d/c.txt"
[ ! -e "${RIGHT_REPO}/d/d.txt" ]
"${thisd}/../inter-git-diff.sh" "$LEFT_REPO" "$RIGHT_REPO"
