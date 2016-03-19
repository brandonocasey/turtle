# @file lib/pre/log.sh
log() {
  msg_color() {
    case "$1" in
      reset) printf "\e[0m" ;;
      bright) printf "\e[1m" ;;
      black) printf "\e[30m" ;;
      red) printf "\e[31m" ;;
      green) printf "\e[32m" ;;
      yellow) printf "\e[33m" ;;
      blue) printf "\e[34m" ;;
      magenta) printf "\e[35m" ;;
      cyan) printf "\e[36m" ;;
      white) printf "\e[37m" ;;
      gray|grey) printf "\e[90m" ;;
      *) return 1;;
    esac
  }
  msg() {
    color="$1"; shift
    label="$1"; shift

    while [ $# -gt 0 ]; do
      msg_color reset
      if [ -n "$label" ]; then
        msg_color "$color"
        printf "${label}"
        msg_color reset
        printf ": "
      fi
      msg_color white
      msg_color bright
      printf "%s\n" "$1"; shift
      msg_color reset
    done
  }
  [ -z "$1" ] && return 1
  [ -z "$2" ] && return 1
  kind="$1"; shift
  case "$kind" in
    error) msg "red" "error" "$@" 1>&2 ;;
    warn) msg "yellow" "warn" "$@" 1>&2 ;;
    info)  msg "cyan" "info" "$@" ;;
    verbose) msg "green" "verbose" "$@" ;;
    debug) msg "magenta" "debug" "$@" ;;
    *) msg "" "" "$@" ;;
  esac
}
