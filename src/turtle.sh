main() {
  [ -z "$1" ] && usage && return 1
  bin="turtle-$1"; shift
  if ! type -f "$bin" >/dev/null 2>&1; then
    log error "No binary named $bin to run"
    return 1
  fi
  "$bin" "$@"
}

lspath () {
  pattern="$1"
  OLD_IFS="$IFS"
  IFS=':'
  for d in $PATH; do
    ls "$d/$pattern"* 2>/dev/null | sed "s~$d/$pattern~~"
  done | sort -u
}

usage() {
  echo
  echo "  manage shell packages"
  echo
  echo "  Commands: "
  echo
  for bin in $(lspath "turtle-"); do
    echo "  turtle $bin"
  done
  echo
  echo " Options:"
  echo "  -h, --help           show help for this binary"
  echo
}
