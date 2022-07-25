{ 
  # Lock all nix-package versions to that which is released atomically together
  pkgs ? (import (builtins.fetchTarball {
           # Release '22.05' is a tag which points to ce6aa13369b667ac2542593170993504932eb836
           url = "https://github.com/nixos/nixpkgs/tarball/22.05";
           # This hash is git-agnostic so nix can detect if the git-tag changes
           sha256 = "0d643wp3l77hv2pmg2fi7vyxn4rwy0iyr8djcw1h5x72315ck9ik";
         }) {}),

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

