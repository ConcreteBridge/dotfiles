declare-option -hidden str explore_buffers_current

set-face global ExploreBuffers 'yellow,default'

add-highlighter shared/*buffers*                 regions
add-highlighter shared/*buffers*/content         region '^' '$' group
add-highlighter shared/*buffers*/content/buffers regex '^.+$' 0:ExploreBuffers

hook global WinSetOption filetype=\*buffers\* %{
  add-highlighter window/ ref *buffers*
  map window normal j     %{jx_<a-;>}
  map window normal k     %{kx_<a-;>}
  map window normal C     %{;Cx_<a-;>}
  map window normal <a-C> %{;<a-C>x_<a-;>}
  map window normal h     ':nop<ret>'
  map window normal l     ':explore-buffers-validate<ret>'
  map window normal d     ':explore-buffers-close<ret>'
  map window normal q     ':delete-buffer<ret>'
  # map window normal -     ':explore-buffers-parent<ret>'
  hook -always -once window WinSetOption filetype=.* %{
    remove-highlighter window/buffers
  }
}

define-command -hidden show-explore-buffers-options %{
  info -title 'Explore Buffers' "l: open buffer
d: close buffer (confirm)
q: quit
"
}

hook -group explore-buffers global WinCreate .* %{
  explore-buffers-enable
}

define-command -hidden explore-buffers -docstring 'Explore buffers' %{ evaluate-commands -save-regs '"/' %{
  set-option current explore_buffers_current %val{bufname}
  edit! -scratch *buffers*
  set-option buffer filetype *buffers*
  set-register dquote %val{buflist}
  execute-keys '<a-R>)a<ret><esc>,'
  set-register / "^\Q%opt{explore_buffers_current}\E"
  execute-keys %{n<a-;>}
  show-explore-buffers-options
  # echo -markup {Information} %{Showing buffers}
}}

define-command -hidden explore-buffers-parent -docstring 'Explore the parent directory of the selected buffer' %{
  explore-buffers-validate
  explore-files %sh(dirname "$kak_buffile")
}

define-command -hidden explore-buffers-validate -docstring 'Edit selected buffer' %{
  execute-keys 'x_'
#   evaluate-commands %sh{
#     if test $kak_selection_count -gt 1; then
#       ( while IFS= read -r var; do printf 'repl-new kak -c "%s" -e "buffer %s"\n' "$kak_session" "$var"; done ) << EOF
# $(echo $kak_selections)
# EOF
#     else
#       printf %s 'buffer %reg(.)'
#     fi
#   }
  buffer %reg(.)
  delete-buffer *buffers*
}

define-command -hidden explore-buffers-close -docstring 'Close selected buffer' %{
  execute-keys 'x_'
  info -title "*buffers*" "Close '%reg(.)'?
y: yes
n: no"

  on-key %{ eval %sh{
    case $kak_key in
    y | Y)
      echo 'delete-buffer %reg(.)'
      echo 'explore-buffers'
      ;;
    *)
      echo 'execute-keys :nop<ret>'
      ;;
    esac
  }}

  # delete-buffer %reg(.)
  # explore-buffers
}

define-command -hidden explore-buffers-enable %{
  hook window -group explore-buffers RuntimeError '\d+:\d+: ''(buffer|b)'' wrong argument count' %{
    # Hide error message
    echo
    explore-buffers
  }
}

