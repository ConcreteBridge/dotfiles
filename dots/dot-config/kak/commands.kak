# COMMANDS #

define-command -override -docstring "find files" -params 1 \
  find %{ edit %arg{1} }
complete-command find shell-script-candidates %{ fd . }

define-command -override -docstring "find all files" -params 1 \
  find-all %{ edit %arg{1} }
complete-command find-all shell-script-candidates %{ fd --hidden --no-ignore . }

define-command -override -docstring "find configuration files" -params 1 \
  find-config %{ edit %arg{1} }
complete-command find-config shell-script-candidates %{ fd --hidden --no-ignore . $kak_config }

define-command -override -docstring "change working directory" -params 1 \
  zoxide %{ cd %arg{1} }
complete-command zoxide shell-script-candidates %{ zoxide query --list }

define-command -override -docstring "surround selections" -params 2 \
  surround %{ execute-keys "_i%arg{1}<esc>a%arg{2}<esc><s-h>_" }

define-command -override -docstring "flygrep: run grep on every key" \
  flygrep %{
    edit -scratch *grep*
    prompt "flygrep: " -on-change %{
        flygrep-call-grep %val{text}
    } nop
  }

define-command -override -docstring "flygrep: actually run grep" -params 1 \
  flygrep-call-grep %{ evaluate-commands %sh{
    length=${#1}
    [ -z "${1##*&*}" ] && text=$(printf "%s\n" "$1" | sed "s/&/&&/g") || text="$1"
    if [ ${length:-0} -gt 2 ]; then
        printf "%s\n" "info"
        printf "%s\n" "evaluate-commands %{grep '$text'}"
    else
        printf "%s\n" "info -title flygrep %{$((3-${length:-0})) more chars}"
    fi
  }}
