#!/usr/bin/env bash

function joinlower {
  local STR="$2"
  for ELEM in "${@:3}"; do
    STR="${STR}${1}${ELEM}"
  done
  echo $STR | awk '{print tolower($0)}'
}

function browse {
  if uname -a | grep -q Darwin; then
    open $@
  else
    xdg-open $@
  fi
}

function start {
  local SET=$1
  local CHAL=$2

  local BASEURL="https://cryptopals.com"
  local SETURL="${BASEURL}/sets/$SET"
  local CHALURL="${SETURL}/challenges/$CHAL"

  local NAME="$(curl $SETURL 2>/dev/null | grep challenges/$CHAL | cut -d\> -f2 | cut -d\< -f1)"
  local PROJ="$(joinlower "_" "cryptopals" $SET $CHAL $NAME)"

  cargo new $PROJ --lib
  local FILE="${PROJ}/src/lib.rs"

  echo "// Cryptopals crypto challenge - set $SET challenge $CHAL
// $CHALURL

$(cat $FILE)" > $FILE.tmp
  mv $FILE.tmp $FILE

  browse $CHALURL
  git add $PROJ

  $EDITOR $FILE
}
