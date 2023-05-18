{
  outputs = inputs: let
    callFlake = import ./call-flake.nix;
  in {
    __functor = _:
      # flake can either be a flake ref expressed as an attribute set or a path to source tree
      flake: {
        # subdir of source root containing the flake.nix
        dir ? "",
      }: let
        src = builtins.fetchTree flake;
      in
        if dir == ""
        then callFlake (builtins.readFile "${src}/flake.lock") src dir
        else callFlake (builtins.readFile "${src}/${dir}/flake.lock") src dir;
  };
}
