main() {
  global=0
  for o in "$@"; do
    case "$o" in
      -g|--global) global=1 ;;
      *) log error "Unknown argument $o" && return 1;;
    esac
  done

  dir="$(pwd)"
  [ $global -eq 1 ] && dir="/usr/local/bin"

  while [ "$dir" != '/' ]; do
    if [ ! -f "$dir/turtle.json" ]; then
      break
    else
      dir="$(dirname "$dir")"
    fi
  done
  [ "$dir" = "/" ] && return 1
  echo "$dir"
}

usage() {
  echo
  echo "  Print the local prefix of the closest parent directory"
  echo "  that contains a turtle.json"
  echo
  echo "  Usage: "
  echo "    turtle-prefix [-g]"
  echo
  echo "  -g, --global  get the global prefix"
  echo
}
