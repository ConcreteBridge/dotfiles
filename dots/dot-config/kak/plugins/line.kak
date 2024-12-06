# set-option global modelinefmt %{ %sh{
#   left=""
#   center="$kak_buffile"
#   right="[$kak_opt_filetype]"
# 
#   offset=$(bc -e "($kak_window_width - ${#left} - ${#center} - ${#right}) / 2")
#   offset=$(printf "%${offset}.s")
# 
#   printf '%s %s %s' "$left" "$center" "$offset" "$right"
# }}

set-option -add global modelinefmt %sh{ echo " [${kak_opt_filetype:-unknown}]" }
