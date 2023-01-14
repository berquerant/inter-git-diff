#!/bin/bash

set -e

thisd="$(cd $(dirname $0); pwd)"
./prepare.sh

got="/tmp/got"
! IGD_DIFF_DETAIL=1 ../inter-git-diff.sh "$LEFT_REPO" "$RIGHT_REPO" > "$got"

want="/tmp/want"
cat - > "$want" <<EOT
Check /tmp/left/README.md and /tmp/right/README.md
Check /tmp/left/a.txt and /tmp/right/a.txt
1c1
< A
---
> Ad
Diff /tmp/left/a.txt /tmp/right/a.txt
Check /tmp/left/aa.txt and /tmp/right/aa.txt
diff: /tmp/right/aa.txt: No such file or directory
Not exist /tmp/left/aa.txt
Check /tmp/left/d/b.txt and /tmp/right/d/b.txt
1c1
< B
---
> Bd
Diff /tmp/left/d/b.txt /tmp/right/d/b.txt
Check /tmp/left/d/c.txt and /tmp/right/d/c.txt
Check /tmp/left/d/d.txt and /tmp/right/d/d.txt
diff: /tmp/left/d/d.txt: No such file or directory
Not exist /tmp/right/d/d.txt
EOT

diff "$want" "$got"
