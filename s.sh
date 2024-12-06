#!/usr/bin/env sh

_base="stow --dotfiles --verbose --target $HOME"
# _dots="$(dirname $(realpath $0))/dots"

dots_add() {
  $_base dots
}

dots_remove() {
  $_base --delete dots
}

echo BASE $_base
echo DOTS $_dots

"dots_$1"
