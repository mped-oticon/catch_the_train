#!/usr/bin/env bash
export PATH="$PATH:$HOME/.nix-profile/bin"

{
  nix-shell shell.nix --pure --run "python3 catch_the_train/__init__.py"
} | awk 'NR>=2{print $1, $3}'

