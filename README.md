# inter-git-diff.sh

```
inter-git-diff.sh compares files between repos.

Usage:

inter-git-diff.sh LEFT_REPO RIGHT_REPO

LEFT_REPO is the path to comparison source repo.
RIGHT_REPO is the path to comparson destination repo.

Environment variables:

  IGD_DIFF_DETAIL:
    If 1, display the details of the diff.

  IGD_REPLACE:
    If 1, apply patches to RIGHT_REPO.
    Patches are for:
    - a file that exists in LEFT_REPO but not in RIGHT_REPO
    - a file that exists in LEFT_REPO and RIGHT_REPO but has some diff

Exit status is 0 if inputs are the same.
```

# Example

left repo:
```
left
├── README.md
├── a.txt
├── aa.txt
└── d
    ├── b.txt
    └── c.txt
```

right repo:
```
right
├── README.md
├── a.txt (with diff)
└── d
    ├── b.txt (with diff)
    ├── c.txt
    └── d.txt
```

then

``` sh
❯ ./inter-git-diff.sh /path/to/left /path/to/right
Diff /path/to/left/a.txt /path/to/right/a.txt
Not exist /path/to/right/aa.txt
Diff /path/to/left/d/b.txt /path/to/right/d/b.txt
Not exist /path/to/left/d/d.txt
```
