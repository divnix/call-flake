{
  outputs = inputs: let
    callFlake = import ./call-flake.nix;
  in {
    __functor = _:
      # ref can either be expressed as an attribute set or a path to source tree
      ref: let
        # if expressed as attribute set, a dir argument may be added to point to a subref
        dir = ref.dir or "";
        src = if builtins.isPath ref' then { outPath = ref'; } else builtins.fetchTree ref';
        ref' =
         if builtins.isAttrs ref
         then builtins.removeAttrs ref ["dir"]
         else ref;
        defaultLock = builtins.toJSON {
          nodes.root = {};
          root = "root";
        };
        readOrDefault = path:
          if builtins.pathExists path
          then builtins.readFile path
          else defaultLock;
      in
        if dir == ""
        then callFlake (readOrDefault "${src}/flake.lock") src dir
        else callFlake (readOrDefault "${src}/${dir}/flake.lock") src dir;
  };
}
