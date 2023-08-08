{ lib, ... }: {
  imports = let
    files = map (x: ./. + "/${x}") (builtins.filter (x:
      lib.hasSuffix ".nix" x
      && x != "configuration.nix"
    ) (builtins.attrNames (builtins.readDir ./.)));
  in files;
}
