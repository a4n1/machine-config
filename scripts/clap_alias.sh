clap_alias() {
  local name cmd cmd_q

  if [[ "$1" == *=* ]]; then
    name="${1%%=*}"
    cmd="${1#*=}"
  else
    name="$1"
    cmd="$2"
  fi

  alias "$name=$cmd"

  printf -v cmd_q '%q ' $cmd
  cmd_q="${cmd_q% }"

  eval "
_${name}_complete() {
  local -a parts
  eval \"parts=($cmd_q)\"

  local cmd0=\"\${parts[0]}\"
  local -a inject=(\"\${parts[@]:1}\")

  local -a orig_words=(\"\${COMP_WORDS[@]}\")
  local orig_cword=\$COMP_CWORD

  COMP_WORDS=(\"\$cmd0\" \"\${inject[@]}\" \"\${orig_words[@]:1}\")
  COMP_CWORD=\$((orig_cword + \${#inject[@]}))

  \"_clap_complete_\$cmd0\"

  COMP_WORDS=(\"\${orig_words[@]}\")
  COMP_CWORD=\$orig_cword
}
complete -o nospace -o bashdefault -o nosort -F _${name}_complete $name
"
}
