# @file lib/post/return.sh
# we can only return here if we are sourced
$(return >/dev/null 2>&1)
is_sourced="$?"

if [ $is_sourced -eq 0 ]; then
  echo "Sourcing is not supported!"
  return
fi

for o in "$@"; do
  case "$o" in
    -h|--help) usage && exit 0;;
  esac
done

main "$@"
exit "$?"
