#!/usr/bin/env bash
cd "$(dirname $(readlink -f ${BASH_SOURCE[0]}))/.."
export PATH="$PATH:$HOME/.nix-profile/bin"

{
  nix-shell shell.nix --pure --run "python3 catch_the_train/__init__.py"
} | sort | awk 'NR<=2{print $1, $3}'

