# KEYBINDS #

declare-user-mode do
map global normal ' ' ':enter-user-mode do<ret>'
map -docstring 'find'        global do 'f' ':find '
map -docstring 'find-all'    global do 'F' ':find-all '
map -docstring 'find-config' global do 'C' ':find-config '
map -docstring 'buffer'      global do 'b' ':buffer '
map -docstring 'flygrep'     global do 'g' ':flygrep<ret>'
map -docstring 'zoxide'      global do 'z' ':zoxide '
map -docstring 'comment'     global do 'c' ':comment-line<ret>'
map -docstring 'yank'        global do 'y' '!xsel -bi<ret>'

declare-user-mode surround
map -docstring 'surround'      global do       's' ':enter-user-mode surround<ret>'
map -docstring 'parentheses'   global surround 'b' ':surround ( )<ret>'
map -docstring 'parentheses'   global surround '(' ':surround ( )<ret>'
map -docstring 'parentheses'   global surround ')' ':surround "( " " )"<ret>'
map -docstring 'braces'        global surround 'B' ':surround { }<ret>'
map -docstring 'braces'        global surround '{' ':surround { }<ret>'
map -docstring 'braces'        global surround '}' ':surround "{ " " }"<ret>'
map -docstring 'brackets'      global surround 'r' ':surround [ ]<ret>'
map -docstring 'brackets'      global surround '[' ':surround [ ]<ret>'
map -docstring 'brackets'      global surround ']' ':surround "[ " " ]"<ret>'
map -docstring 'angles'        global surround 'a' ':surround <lt>lt<gt> <lt>gt<gt><ret>'
map -docstring 'angles'        global surround '<' ':surround <lt>lt<gt> <lt>gt<gt><ret>'
map -docstring 'angles'        global surround '>' ':surround "<lt>lt<gt> " " <lt>gt<gt>"<ret>'
map -docstring 'double quotes' global surround '"' %{:surround '"' '"'<ret>}
map -docstring 'double quotes' global surround 'Q' %{:surround '"' '"'<ret>}
map -docstring 'single quotes' global surround "'" %{:surround "'" "'"<ret>}
map -docstring 'single quotes' global surround 'q' %{:surround "'" "'"<ret>}
map -docstring 'graves'        global surround '`' ':surround ` `<ret>'
map -docstring 'graves'        global surround 'g' ':surround ` `<ret>'
