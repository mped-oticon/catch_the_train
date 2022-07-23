{ pkgs ? import <nixpkgs> {},
  allthepoetrystuff ? import ./default.nix {} 
}:

pkgs.mkShell {

  buildInputs = [
    pkgs.python3
    pkgs.poetry
  ]
  # If absent, let's omit all the poetry stuff, but still give the user
  # a chance to produce it - within a suitable shell containing poetry.
  ++
  (if builtins.pathExists ./poetry.lock then [ allthepoetrystuff ]
  else []);

  dir_of_this_nix_file = ./.;

  shellHook =
    if builtins.pathExists ./poetry.lock then ''
      cd $dir_of_this_nix_file
      #echo "Yay poetry.lock exists. I'll honor it"
      #echo "You have a perfectly usable environment now :)"
    ''
    else ''
      cd $dir_of_this_nix_file
      echo "Boo! You don't have a lock file - so I'll make it now"
      poetry lock || exit 1
      echo "Lockfile created. But this nix-shell is unusable; start it again. Exiting for now."
      exit 2
    ''
  ;
}

