#!/bin/bash

[[ $# -lt 1 ]] && echo "Usage: $0 DIR" && exit 1

DIR=$1

for fn in $(find $DIR); do
  if [[ -f $fn ]]; then
    bd=$(dirname $fn)
    bn=$(basename $fn)
    nbn=$(echo $bn | tr A-Z a-z)
    echo "$bd/$nbn"
  else
    echo $fn
  fi
done

exit 0
