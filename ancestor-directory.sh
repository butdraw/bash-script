#!/bin/bash
# Usage:
#   source ancestor-directory.sh
# Example:
#   $ echo 'alias ad="source /path/ancestor-directory.sh"' >> ~/.bashrc
#   $ source ~/.bashrc
#   $ ad
#   /home/user/some/path
#   ----3----2----1----0
#   (input a number)

repeat() {
    local str=''
    for i in $(seq 1 $(($1))); do str+=$2; done
    echo "$str"
}

pwd=$PWD
pdir=$pwd
dirs=("$pwd")
line=""

while [[ "$pdir" != "/" ]]; do
    pdir=$(dirname "$pwd")
    dirs+=("$pdir")
    pwd=$pdir
done

if [[ -n "${@}" ]]; then
    if [[ ${@} =~ (^[0-9]+$) && ${@} -lt ${#dirs[@]} ]]; then
        cd ${dirs[${@}]}
    fi
else
    line=$(repeat ${#dirs[0]} '-')
    for i in "${!dirs[@]}"; do
        if [[ $i -lt 100 && $i -lt ${#dirs[@]}-1 ]]; then
            line=${line:0:${#dirs[$i]}-${#i}}$i${line:${#dirs[$i]}}
        fi
    done
    echo "${dirs[0]}"
    echo "$line"
    read -s -e id
    if [[ $id =~ (^[0-9]+$) && $id -lt ${#dirs[@]} ]]; then
        cd ${dirs[$id]}
    fi
fi