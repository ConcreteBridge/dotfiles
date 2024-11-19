################################################################################
# UTILITY FUNCTIONS
################################################################################


define-command -hidden -params 2 _build-surround-command %!
  eval %sh{
    command="$1";
    case "$2" in
    b | \( | \) )         # Parentheses;
      open='('
      close=')'
      ;;
    B | \{ | \} )         # Braces;
      open='{'
      close='}'
      ;;
    r | \[ | \] )         # Brackets;
      open='['
      close=']'
      ;;
    a | '<lt>' | '<gt>' ) # Angles;
      open='<lt>'
      close='>'
      ;;
    q | \' )              # Single quotes;
      open="<'>"
      close="<'>"
      ;;
    Q | \" )              # Double quotes;
      open='<">'
      close='<">'
      ;;
    g | \` )              # Graves;
      open='`'
      close='`'
      ;;
    * )                   # Any other character;
      open="$2"
      close="$2"
      ;;
    esac
    echo "$command $open $close"
  }
!

# (A.) Show the `info` dialog box.
define-command -hidden -params 2 _show-surround-info-for %{
  info -title "%arg{1}" "%arg{2}"
}

define-command -hidden -params 1 _save-selections %{
  # Save selections to the `s` register.
  execute-keys "<"">%arg{1}Z:nop<ret>"
}

define-command -hidden -params 1 _restore-selections %{
  # Restore selections to the `s` register.
  execute-keys "<"">%arg{1}z:nop<ret>"
}



################################################################################
# ADD SURROUND
################################################################################


# Process an `add surround` request.
define-command add-surround %{
  # See (A.)
  _show-surround-info-for 'add surround' 'b,(,):  parentheses
B,{,}:  braces
r,[,]:  brackets
a,<,>:  angles
",Q:    double quotes
'',q:    single quotes
`,g:    graves
t:      markup tags
others: any character'

  # Store key selection to the `key` variable:
  on-key %{ eval %sh{
    case $kak_key in
    t)
      echo 'surround-with-tag'
      ;;
    *) # See (B.)
      echo "_build-surround-command _add-surround %val{key}"
      ;;
    esac
  }}
}

# (B.) Prepend and append the appropriate surround characters.
define-command -hidden -params 2 _add-surround %{
  execute-keys "i%arg{1}<esc><S-h>a%arg{2}<esc>"
}


################################################################################
# DELETE SURROUND
################################################################################


# Process an `delete surround` request.
define-command delete-surround %{
  # See (A.)
  _show-surround-info-for 'delete surround' 'b,(,):  parentheses
B,{,}:  braces
r,[,]:  brackets
a,<,>:  angles
",Q:    double quotes
'',q:    single quotes
`,g:    graves
t:      markup tags'

  # 'Store' key selection to the `key` variable:
  on-key %{ eval %sh{
    case $kak_key in
    b | \( | \) | B | \{ | \} | r | \[ | \] | a | '<lt>' | '<gt>' | q | \' | Q | \" | g | \`)
      echo '_save-selections x'
      # See (C.)
      echo "_select-surrounding-pair %val{key}"
      echo 'execute-keys d' # Delete the selected surround characters
      echo '_restore-selections x'
      ;;
    t)
      echo 'delete-surrounding-tag'
      ;;
    *) # To close `info` window, use execute-keys:
      echo 'execute-keys :nop<ret>'
      ;;
    esac
  }}
}

# (C.) Select the appropriate surround characters.
define-command -hidden -params 1 _select-surrounding-pair %{
  execute-keys "<a-a>%arg{1}<a-S>"
}


################################################################################
# REPLACE SURROUND
################################################################################


# Process an `replace surround` request.
define-command replace-surround %{
  # See (A.)
  _show-surround-info-for 'replace surround' 'replace:
  b,(,):  parentheses
  B,{,}:  braces
  r,[,]:  brackets
  a,<,>:  angles
  ",Q:    double quotes
  '',q:    single quotes
  `,g:    graves
  t:      markup tags'

  # Store key selection to the `key` variable:
  on-key %{ eval %sh{
    case $kak_key in
    b | \( | \) | B | \{ | \} | r | \[ | \] | a | '<lt>' | '<gt>' | q | \' | Q | \" | g | \`)
      # See (D.)
      echo "_build-surround-command _replace-surround %val{key}"
      ;;
    t)
      echo 'replace-surrounding-tag'
      ;;
    *) # To close `info` window, use execute-keys:
      echo 'execute-keys :nop<ret>'
      ;;
    esac
  }}
}

# (D.) Ask for new surround replacement characters.
define-command -hidden -params 2 _replace-surround %{
  execute-keys "<a-a>%arg{1}"

  # See (A.)
  _show-surround-info-for 'replace surround' 'with:
  b,(,):  parentheses
  B,{,}:  braces
  r,[,]:  brackets
  a,<,>:  angles
  ",Q:    double quotes
  '',q:    single quotes
  `,g:    graves'

  # Store key 'selection' to the `key` variable:
  on-key %{ eval %sh{
    case $kak_key in
    b | \( | \) | B | \{ | \} | r | \[ | \] | a | '<lt>' | '<gt>' | q | \' | Q | \" | g | \`)
      # See (E.)
      echo "_build-surround-command _replace-surround-with %val{key}"
      ;;
    *) # To close `info` window, use execute-keys:
      echo 'execute-keys :nop<ret>'
      ;;
    esac
  }}
}

# (E.) Replace the surrounding characters with the new selection.
define-command -hidden -params 2 _replace-surround-with %{
  _save-selections x
  execute-keys "<a-;>;r%arg{1}" # Replace the `open` character.
  _restore-selections x
  execute-keys ";r%arg{2}" # Replace the `close` character.
  _restore-selections x
  execute-keys "<s-h><s-h>" # Shift selection back within then surround.
}


################################################################################
# TAG SURROUND
################################################################################


## #use evaluate-commands to collapse undo history
## define-command surround-with-tag %{ evaluate-commands %{
##   #first append, to put cursor inside inserting tag pair
##   execute-keys 'a<lt>/><esc>i<lt>><esc>'
##   execute-keys '<a-a>c<lt>>,<lt>/><ret>'
##   execute-keys '<a-S><a-a>>s><ret>)'
##   _activate-hooks-tag-attribute-handler
##   execute-keys -with-hooks i
## }}

## define-command delete-surrounding-tag %{
##   evaluate-commands -itersel _select-surrounding-tag-including-space
##   execute-keys d
## }

## define-command change-surrounding-tag %{
##   evaluate-commands -itersel _select-boundary-of-surrounding-tag
##   execute-keys '<a-i>c<lt>/?,><ret>)'
##   _activate-hooks-tag-attribute-handler
##   execute-keys -with-hooks c
## }

## define-command select-surrounding-tag %{
##   evaluate-commands -itersel _select-boundary-of-surrounding-tag
##   execute-keys '<a-a>c<lt>/?,><ret>'
## }

## define-command -hidden _activate-hooks-tag-attribute-handler %{
##   hook -group surround-tag-attribute-handler window RawKey '<space>' %{
##     execute-keys '<backspace>'
##     _keep-odds
##     execute-keys '<space>'
##     remove-hooks window surround-tag-attribute-handler
##   }
##   hook -group surround-tag-attribute-handler window ModeChange insert:normal %{
##     remove-hooks window surround-tag-attribute-handler
##   }
## }

## #for multiple selection
## #odd selections is open tag
## #even selections is close tag
## define-command -hidden _keep-odds %{ eval %sh{
##   accum_selections=
##   is_odd=0
##   for selection in $kak_selections_desc ; do
##     if [ $is_odd -eq 0 ] ; then
##       is_odd=1
##       accum_selections="$accum_selections $selection"
##     else
##       is_odd=0
##     fi
##   done
##   #accum_selections has space on head
##   echo "select$accum_selections"
## }}

## #use evaluate-commands to restore mark
## define-command -hidden _select-surrounding-tag-including-space %{ evaluate-commands %{
##   _select-boundary-of-surrounding-tag
##   execute-keys -save-regs '' 'Z<space><a-a>c\\s*<lt>/,><ret><a-Z>a'
##   execute-keys -save-regs '' 'z(<space><a-a>c<lt>,>\\h*\\n?<ret>'
##   execute-keys -save-regs '' '<a-z>a'
## }}

## define-command -hidden _select-boundary-of-surrounding-tag %{
##   execute-keys \;
##   #handle inside open tag
##   try %{
##     #<a-a>> produce side effect inside close tag
##     #that make tag_list include the close tag
##     execute-keys -draft '<a-a>c<lt>/,><ret>'
##   } catch %{
##     try %{
##       execute-keys '<a-a>>'
##     }
##   }
##   execute-keys 'Ge<a-;>'
##   eval %sh{
##     tag_list=`echo "$kak_selection" | grep -P -o '(?<=<)[^>]+(?=>)' | cut -d ' ' -f 1`
##     open=
##     open_stack=
##     result=
##     for tag in $tag_list ; do
##       if [ `echo $tag | cut -c 1` != / ] ; then
##         case $tag in
##         #self-closing tags
##         area|base|br|col|command|embed|hr|img|input|keygen|link|meta|param|source|track|wbr) continue ;;
##         *)
##           open=$tag
##           open_stack=$open\\n$open_stack ;;
##         esac
##       else
##         if [ $tag = /$open ] ; then
##           open_stack=${open_stack#*\\n}
##           open=`echo $open_stack | head -n 1`
##         else
##           result=${tag#/}
##           break
##         fi
##       fi
##     done
##     echo "execute-keys '<a-a>c<lt>$result\s?[^>]*>,<lt>/$result><ret>'"
##   }
##   execute-keys '<a-S>'
## }
