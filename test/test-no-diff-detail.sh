#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"
./prepare.sh

got="/tmp/got"
../inter-git-diff.sh "$LEFT_REPO" "$RIGHT_REPO" > "$got"

want="/tmp/want"
cat - > "$want" <<EOT
Check /tmp/left/README.md and /tmp/left/README.md
Check /tmp/left/a.txt and /tmp/left/a.txt
Check /tmp/left/aa.txt and /tmp/left/aa.txt
Check /tmp/left/d/b.txt and /tmp/left/d/b.txt
Check /tmp/left/d/c.txt and /tmp/left/d/c.txt
EOT

diff "$want" "$got"
