#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"
./prepare.sh

got="/tmp/got"
! ../inter-git-diff.sh "$LEFT_REPO" "$RIGHT_REPO" > "$got"

want="/tmp/want"
cat - > "$want" <<EOT
Diff /tmp/left/a.txt /tmp/right/a.txt
Not exist /tmp/left/aa.txt
Diff /tmp/left/d/b.txt /tmp/right/d/b.txt
Not exist /tmp/right/d/d.txt
EOT

diff "$want" "$got"
