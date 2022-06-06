#!/usr/bin/env bash

function normalize {
  echo "$@" | awk '{print tolower($0)}' | sed -E 's/[^[:alnum:]]+/_/g'
}

function browse {
  if uname -a | grep -q Darwin; then
    open "$@"
  else
    xdg-open "$@"
  fi
}

BASEURL="https://cryptopals.com"

function seturl {
  echo "$BASEURL/sets/$1"
}

function chalurl {
  echo "$BASEURL/sets/$1/challenges/$2"
}

function chalname {
  curl "$(seturl "$1")" 2>/dev/null | grep "challenges/$2'" | cut -d\> -f2 | cut -d\< -f1
}

function chalexists {
  curl "$(seturl "$1")" 2>/dev/null | grep -q "challenges/$2'"
}

function start {
  local SET=$1
  local CHAL=$2

  local NAME
  NAME="$(chalname "$SET" "$CHAL")"
  local PROJ
  PROJ="cryptopals_${SET}_${CHAL}_$(normalize "$NAME")"

  cargo new "$PROJ" --lib
  local FILE="${PROJ}/src/lib.rs"

  echo "// Cryptopals crypto challenge - set $SET challenge $CHAL
// $(chalurl "$SET" "$CHAL")

$(cat "$FILE")" > "$FILE.tmp"
  mv "$FILE.tmp" "$FILE"

  browse "$(chalurl "$SET" "$CHAL")"
  $EDITOR "$FILE"
}

function next {
  local LATEST_SET
  LATEST_SET=$(find . -type d -name "cryptopals_*" | cut -d_ -f2 | uniq | sort -g | tail -1)
  local LATEST_CHAL
  LATEST_CHAL=$(find . -type d -name "cryptopals_$LATEST_SET*" | cut -d_ -f3 | sort -g | tail -1)

  if [[ "" == "$LATEST_CHAL" ]]; then
    echo "No challenges found, starting at 1-1"
    start 1 1
    return
  fi

  local NEXT_SET=$LATEST_SET
  local NEXT_CHAL=$((LATEST_CHAL + 1))
  if ! chalexists "$LATEST_SET" "$NEXT_CHAL"; then
    NEXT_SET=$((LATEST_SET + 1))
  fi

  if chalexists $NEXT_SET $NEXT_CHAL; then
    echo "Starting next challenge, $NEXT_SET-$NEXT_CHAL"
    start $NEXT_SET $NEXT_CHAL
  else
    echo "Set $NEXT_SET not found. You must be done!"
  fi
}

function startover {
  rm -rf cryptopals_*
}
