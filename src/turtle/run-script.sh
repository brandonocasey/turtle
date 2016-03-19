main() {
  [ -z "$1" ] && log error "must pass in script name"
  name="$1"; shift

  script="$(turtle-config get "scripts.$name")"
  if [ $? -ne 0 ] || [ -z "$script" ]; then
    log error "$name is not a valid script name"
  fi

  log info "Running $name as" "$script"
  "$script" "$@"
}

usage() {
  echo
  echo "  run package scripts as configured in turtle.json"
  echo
  echo "  Usage: "
  echo "    turtle-run-script test"
  echo "    turtle-run-script start"
  echo
}
