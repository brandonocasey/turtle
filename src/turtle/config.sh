main() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    log error "action and key required --help for help"
    return 1
  fi
  a="$1"; shift
  case "$a" in
    get) a="get";;
    set) a="set";;
    del) a="del";;
    *) log error "valid actions are get, set, or del --help for help" && return 1;;
  esac
  "$a" "$@"
  return "$?"
}

get() {
  k="$1"; shift
  echo "get $k"

}

set() {
  k="$1"; shift
  v=""
  [ -n "$1" ] && v="$1" && shift
  echo "set $k -> $v"
}

del() {
  k="$1"; shift
  echo "del $k"
}

usage() {
  echo
  echo "  get set and delete values in the current directories config"
  echo
  echo "  Usage: "
  echo "    turtle-config <action> <key>"
  echo "    turtle-config get <key>"
  echo "    turtle-config set <key> <val>"
  echo "    turtle-config del <key>"
  echo
}
