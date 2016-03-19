#!/usr/bin/env bash
DIST='./dist'
SRC='./src'
LIB='./lib'
walk() {
  for file in $1; do
    [ "$file" = "$1" ] && return
    [ -d "$file" ] && walk "$file/*" && continue
    echo "$file"
  done
}

append() {
  nl="
"
  for s in "$@"; do
    [ -z "$s" ] && continue
    [ -f "$s" ] && echo "$(cat "$s")$nl" && continue
    [ -n "$s" ] && echo "${s}${nl}"
  done
}

base() {
  current="$(basename "$1")"; shift
  while [ "$last" != "$current" ]; do
    last="$current"
    current="${current%.*}"
  done
  echo "$current"
}

do_clean() {
  if [ -d "$DIST" ]; then
    rm -rf "$DIST"
  fi
}

do_build() {
  pre=""
  post=""
  for file in $(walk "$LIB/pre/*"); do
    pre="$(append "$pre" "$file")"
  done

  for file in $(walk "$LIB/post/*"); do
    post="$(append "$post" "$file")"
  done

  for file in $(walk "$SRC/*"); do
    dp="${DIST}/$(echo "$file" | sed "s~$SRC\/~~" | sed "s~/~-~g")"
    dp="$(echo "$dp" | sed "s~$(basename "$dp")~$(base "$dp")~")"
    mkdir -p "$(dirname "$dp")"
    echo "$(append "$pre" "$file" "$post")" > "$dp"
    chmod +x "$dp"
    echo "$file -> $dp"
  done
}

# we can only return here if we are sourced
$(return >/dev/null 2>&1)
is_sourced="$?"

if [ $is_sourced -eq 0 ]; then
  echo "Sourcing is not supported!"
  return
fi

action="build"
[ -n "$1" ] && action="$1"

if ! type -t do_"$action" >/dev/null 2>&1; then
  echo "$action is not a valid action"
  exit 1
fi

echo "Running $action"
do_"$action"
exit "$?"
