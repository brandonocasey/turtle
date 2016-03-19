usage() {
  echo
  echo "  install new packages or existing dependancies"
  echo
  echo "  Usage: "
  echo "    turtle-install <github-user>/<github-repo>"
  echo "    turtle-install <github-user>/<github-repo>@<version>"
  echo "    turtle-install <github-user>/<github-repo>@<tag>"
#  echo "    turtle-install <url>"
#  echo "    turtle-install <name>@<version>"
#  echo "    turtle-install <name>@<tag>"
  echo "    turtle-install "
  echo
  echo "  -h, --help           show help for this binary"
  echo "  -S, --save           save packages into dependancies"
  echo "  -D, --save-dev       save packages into devDependancies"
  echo "  -O, --save-optional  save packages into optionalDependancies"
  echo
}

split() {
  char="$1"; shift
  str="$1"; shift

  (
    IFS="$char"
    for s in $str; do
      echo "$s"
    done
  )
}

join() {
  join_char="$1"; shift
  str="$1"; shift

  s=""
  for e in "$str"; do
    [ -z "$s" ] && s="$e" && continue
    echo "${s}$join_char${e}"
    s=""
  done

}

main() {
  save=0
  save_dev=0
  save_opt=0

  i=0
  while [ $i -lt $# ]; do
    o="$1"; shift
    case "$o" in
      -S|--save) save=1 ;;
      -D|--save-dev) save_dev=1 ;;
      -O|--save-optional) save_opt=1 ;;
      -*) log error "Unknown argument $o" && return 1;;
      *) set -- "$@" "$o"
    esac
    let i=i+1
  done

  # TODO: join name version with @
  if [ -z "$1" ]; then
    set -- "$@" "$(join "$(turtle config get dependancies)")"
    set -- "$@" "$(join "$(turtle config get devDependancies)")"
    set -- "$@" "$(join "$(turtle config get optionalDependancies)")"
  fi

  if [ -z "$1" ]; then
    return 1
  fi

  for package in "$@"; do
    pkg=""
    ver="master"
    for s in $(split "@" "$package"); do
      [ -z "$pkg" ] && pkg="$s" && continue
      ver="$s"
    done

    install "$pkg" "$ver"
    [ $? -ne 0 ]  && return 1
    [ $save -eq 1 ] && turtle config set "dependancies.$pkg" "$ver"
    [ $save_dev -eq 1 ] && turtle config set "devDependancies.$pkg" "$ver"
    [ $save_opt -eq 1 ] && turtle config set "optionalDependancies.$pkg" "$ver"
  done
}

check_remote() {
  status="400"
  status=$(curl -s -o /dev/null -w "%{http_code}" "$1")
  if [ "$?" != "0" ] || [ "$status" != "200" ]; then
    return 1
  fi
}

download() {
  curl -sL "$1" > "$2"
}

download_repo() {
  dir="$(dirname "$2")"
  mkdir -p "$dir"
  (cd "$dir" && git clone "$1")
}


install() {
  pkg="$1"; shift
  ver="$1"; shift
  url="https://raw.githubusercontent.com/$pkg/$ver"

  check_remote "$url/turtle.json"
  if [ $? -ne 0 ]; then
    # we have to git clone the whole repo
    download_repo "https://github.com/$pkg" "turtle_modules/$pkg"
    return
  fi

  download "$url/turtle.json" "turtle_modules/$pkg/turtle.json"
  files="$(cd "turtle_modules/$pkg" && turtle config get files)"
  if [ -z "$files" ]; then
    # we have to git clone the whole repo
    download_repo "https://github.com/$pkg" "turtle_modules/$pkg"
    return
  fi

  for file in "$files"; do
    dir="$(dirname "$file")"
    mkdir -p "turtle_modules/$pkg/$dir"
    download "$url/$file" "turtle_modules/$pkg/$file"
  done

  # download all files, or if there is no files entry download_repo

}
