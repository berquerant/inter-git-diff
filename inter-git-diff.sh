#!/bin/bash

set -e

left_repo="$1"
right_repo="$2"
replace_selector="$3"

igd_replace_selector() {
    if [ -z "$replace_selector" ] ; then
        return 0
    fi
    "$replace_selector" "$1"
}

igd_can_replace() {
    igd_replace_selector "$1" && [ "$IGD_REPLACE" = "1" ]
}

igd_diff() {
    if [ "$IGD_DIFF_DETAIL" = "1" ] ; then
        echo "Check $1 and $2"
        diff "$1" "$2"
    else
        diff "$1" "$2" >/dev/null 2>&1
    fi
}

tmp_file="/tmp/igd.tmp"
cd "$left_repo"
git ls > "$tmp_file"
cd "$right_repo"
git ls >> "$tmp_file"
tmp_file_list="/tmp/igd.file.list"
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
                    cp "$target_left" "$target_right"
                else
                    echo "Not exist ${target_left}"
                fi
            else
                echo "Not exist ${target_right}"
            fi
            ;;
    esac
done < "$tmp_file_list" # main shell to update ret_code

exit "$ret_code"
