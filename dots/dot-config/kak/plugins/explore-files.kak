declare-option -docstring 'Whether to show hidden files'      bool explore_files_show_hidden no
declare-option -docstring 'Whether to show files recursively' bool explore_files_show_recursive no

declare-option -hidden str explore_files
declare-option -hidden int explore_files_count

set-face global ExploreFiles       'magenta,default'
set-face global ExploreDirectories 'cyan,default'

add-highlighter shared/*directory*                     regions
add-highlighter shared/*directory*/content             region '^' '$' group
add-highlighter shared/*directory*/content/files       regex '^.+[^/]$' 0:ExploreFiles
add-highlighter shared/*directory*/content/directories regex '^.+/$' 0:ExploreDirectories

hook global WinSetOption filetype=\*directory\* %{
  add-highlighter window/ ref *directory*
  map window normal l     ':explore-files-forward<ret>'
  map window normal h     ':explore-files-back<ret>'
  map window normal j     %{jx_<a-;>}
  map window normal k     %{kx_<a-;>}
  map window normal C     %{;Cx_<a-;>}
  map window normal <a-C> %{;<a-C>x_<a-;>}
  map window normal .     ':explore-files-toggle-hidden<ret>'
  map window normal R     ':explore-files-toggle-recursive<ret>'
  map window normal c     ':explore-files-change-directory<ret>'
  map window normal q     ':delete-buffer<ret>'
  hook -always -once window WinSetOption filetype=.* %{
    remove-highlighter window/*directory*
  }
}

define-command -hidden show-explore-files-options %{
  info -title 'Explore Files' "l: open
h: navigate to parent directory
.: show hidden
R: show recursive
c: set current working directory
q: quit
"
}

define-command -hidden explore-files-display -params 1..2 %{ evaluate-commands %sh{
  command="$1"
  path="$(realpath "${2:-.}")"
  name="$(basename "$path")"
  out="$(mktemp --directory)"
  fifo="$out/fifo"
  last_buffer_name="$(basename "$kak_bufname")"

  mkfifo $fifo
  cd "$path"
  (eval "$command" > $fifo) < /dev/null > /dev/null 2>&1 &
  printf %s "
    edit! -fifo %{$fifo} %{$path}
    set-option buffer filetype '*directory*'

    hook -once window NormalIdle '' %{
      evaluate-commands -save-regs / %{
        set-register / %(^\Q$last_buffer_name\E/?$)
        try %{execute-keys %{nx_<a-;>}}
      }

      # Information
      echo -markup {Information} %{Showing $name/ entries}
      show-explore-files-options
    }

    hook -always buffer BufCloseFifo '' %{nop %sh{rm -r $out}}
"
}}

define-command -hidden explore-files-smart -params 0..1 %{ evaluate-commands %sh{
  file=${1:-.}
  edit=$(test -d "$file" && echo explore-files || echo 'edit!')
  echo "$edit %($file)"
}}

define-command -hidden explore-files -params 0..1 -docstring 'Explore directory entries' %{
  evaluate-commands %sh{
    cmd="fd"
    test $kak_opt_explore_files_show_recursive = false && cmd="$cmd --maxdepth 1"
    test $kak_opt_explore_files_show_hidden = true     && cmd="$cmd --hidden"

    printf '%s "%s" "%s"' explore-files-display "$cmd" '%arg(1)'
  }

  # explore-files-display "fd %sh([ $kak_opt_explore_files_show_recursive = false] || printf %s --maxdepth\ 1) %sh([ $kak_opt_explore_files_show_hidden = true ] && printf %s --hidden)" %arg(1)
}

# define-command -hidden explore-files-recursive -params 0..1 -docstring 'Explore directory entries recursively' %{
#   # explore-files-display "find %sh(test $kak_opt_explore_files_show_hidden = false && echo -not -path ""'*/.*'"")" %arg(1)
#   explore-files-display "fd --follow %sh([ $kak_opt_explore_files_show_hidden = true ] && printf %s --hidden)" %arg(1)
# }

define-command -hidden explore-files-forward -docstring 'Edit selected files' %{
  set-option current explore_files %val(bufname)
  execute-keys 'x_'
  set-option current explore_files_count %sh(count() { echo $#; }; count $kak_selections_desc)
  evaluate-commands -draft -itersel -save-regs 'F' %{
    set-register F "%val(bufname)/%reg(.)"
    evaluate-commands -client %val(client) %(explore-files-smart %reg(F))
  }
  delete-buffer %opt(explore_files)
  evaluate-commands %sh{
    count=$kak_opt_explore_files_count
    test $count -gt 1 &&
      printf %s "echo -markup {Information} %[$count files opened]"
  }
}

define-command -hidden explore-files-back -docstring 'Explore parent directory' %{
  set-option current explore_files %val(bufname)
  explore-files "%opt(explore_files)/.."
  delete-buffer %opt(explore_files)
  echo -markup {Information} "Showing %sh(basename ""$kak_bufname"")/ entries"
}

define-command -hidden explore-files-change-directory -docstring 'Change directory and quit' %{
  change-directory %val{bufname}
  echo -markup {Information} "Directory changed to %val{bufname}"
}

define-command -hidden explore-files-toggle-hidden -docstring 'Toggle hidden files' %{
  set-option current explore_files_show_hidden %sh{
    if test $kak_opt_explore_files_show_hidden = true; then
      echo no
    else
      echo yes
    fi
  }
  explore-files %val{bufname}
}

define-command -hidden explore-files-toggle-recursive -docstring 'Toggle recursive files' %{
  set-option current explore_files_show_recursive %sh{
    [ $kak_opt_explore_files_show_recursive = true ] && echo no || echo yes
  }
  explore-files %val{bufname}
}

define-command -hidden explore-files-enable %{
  hook window -group explore-files RuntimeError '\d+:\d+: ''(?:edit|e)'' wrong argument count' %{
    explore-files %sh(dirname "$kak_buffile")
  }
  hook window -group explore-files RuntimeError '\d+:\d+: ''(?:edit|e)'' (.+): is a directory' %{
    # Hide error message
    echo
    explore-files %val(hook_param_capture_1)
  }
  hook window -group explore-files RuntimeError 'unable to find file ''(.+)''' %{
    # Hide error message
    echo
    explore-files-smart %val(hook_param_capture_1)
  }
}

hook -group explore-files global WinCreate .* %{
  explore-files-enable
}

hook -group explore-files global KakBegin .* %{ hook -once global WinCreate .* %{ hook -once global NormalIdle '' %{
  try %{ evaluate-commands -draft -save-regs '/' %{
    buffer *debug*
    set-register / 'error while opening file ''(.+?)'':\n\h+(.+?): is a directory'
    execute-keys '%1s<ret>'
    evaluate-commands -draft -itersel %{
      evaluate-commands -client %val(client) explore-files %reg(.)
    }
  }}
}}}
