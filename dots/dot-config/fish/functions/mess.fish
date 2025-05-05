function mess --description 'mess directory'
  set now     (date +%Y/%V)
  set current $HOME/mess/$now
  set link    $HOME/mess/current

  if test ! -d $current
    mkdir -p $current
    echo "Created $now"
  end

  if test -e $link -a ! -L $link
    echo "$link is not a symlink; something is wrong."
    return 1
  end

  if test -e $link -a ! $link -ef $current
    unlink $link
    ln -s $current $link
  end

  cd $link
end
