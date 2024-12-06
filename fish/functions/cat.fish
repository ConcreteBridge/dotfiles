function cat --wraps 'bat'
  if test (count $argv) -eq 1
    switch (string split : --field 2 (file --mime-type $argv))
    case "*image*"
      if test (string match "*kitty*" $TERM)
        kitten icat $argv
      else
        open $argv
      end
    case "*"
      bat --paging never --theme base16 $argv
    end
  else
    bat --paging never --theme base16 $argv
  end
end
