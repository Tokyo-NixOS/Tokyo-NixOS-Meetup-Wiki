{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;
  # Project Name
  projectName = "my-project";
  ghc = pkgs.haskellPackages.ghcWithPackages (ps: with ps; [
          # Used ghc packages
          # haskell packages can be listed with 
          # nix-env -f "<nixpkgs>" -qaP -A haskellPackages

        ]);
in
pkgs.stdenv.mkDerivation rec {
  name = projectName;
  buildInputs = [ ghc ];
  shellHook = ''
    eval $(egrep ^export ${ghc}/bin/ghc)
    export PS1="${name}@ghc-ng > "
  '';
}
