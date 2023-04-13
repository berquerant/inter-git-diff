#!/bin/bash

# inter-git-diff.sh compares files between repos.
#
# Usage:
#
# inter-git-diff.sh LEFT_REPO RIGHT_REPO
#
# LEFT_REPO is the path to comparison source repo.
# RIGHT_REPO is the path to comparson destination repo.
#
# Environment variables:
#
#   IGD_DIFF_DETAIL:
#     If 1, display the details of the diff.
#
#   IGD_REPLACE:
#     If 1, apply patches to RIGHT_REPO.
#     Patches are for:
#     - a file that exists in LEFT_REPO but not in RIGHT_REPO
#     - a file that not exists in LEFT_REPO but in RIGHT_REPO
#     - a file that exists in LEFT_REPO and RIGHT_REPO but has some diff

error() {
    echo "$@" >&2
}

left_repo="$1"
right_repo="$2"

arg_ok=1

if [ ! -d "$left_repo" ] ; then
    arg_ok=0
    error "${left_repo} is not a directory"
fi
if [ ! -d "$right_repo" ] ; then
    arg_ok=0
    error "${right_repo} is not a directory"
fi
if [ "$arg_ok" = 0 ] ; then
    error "inter-git-diff.sh LEFT_REPO RIGHT_REPO"
    exit 1
fi

igd_can_replace() {
    [ "$IGD_REPLACE" = "1" ]
}

igd_diff() {
    if [ "$IGD_DIFF_DETAIL" = "1" ] ; then
        echo "Check $1 and $2"
        diff "$1" "$2"
    else
        diff "$1" "$2" >/dev/null
    fi
}

set -e
tmp_file="$(mktemp)"
cd "$left_repo"
git ls-files > "$tmp_file"
cd "$right_repo"
git ls-files >> "$tmp_file"
tmp_file_list="$(mktemp)"
sort "$tmp_file" | uniq > "$tmp_file_list"

set +e
ret_code=0
while read -r target ; do
    target_left="${left_repo}/${target}"
    target_right="${right_repo}/${target}"
    igd_diff "$target_left" "$target_right"
    diff_ret="$?"
    if [ "$diff_ret" -ne 0 ] ; then
        ret_code="$diff_ret"
    fi
    case "$diff_ret" in
        1)
            if igd_can_replace "$target" ; then
                echo "Replace ${target_right} with ${target_left}"
                cp "$target_left" "$target_right"
            else
                echo "Diff ${target_left} ${target_right}"
            fi
            ;;
        2)
            if [ -e "$target_left" ] ; then
                if igd_can_replace "$target" ; then
                    echo "Copy ${target_left} to ${target_right}"
                    if [ -d "$target_left" ] ; then
                        mkdir -p "$(dirname "$target_right")"
                    fi
                    cp "$target_left" "$target_right"
                else
                    echo "Not exist ${target_right}"
                fi
            elif igd_can_replace "$target" ; then
                echo "Remove ${target_right}"
                rm "$target_right"
            else
                echo "Not exist ${target_left}"
            fi
            ;;
    esac
done < "$tmp_file_list" # main shell to update ret_code

exit "$ret_code"
