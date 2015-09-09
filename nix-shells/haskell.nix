{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;
  # プロジェクト名
  projectName = "my-project";
  ghc = pkgs.haskellngPackages.ghcWithPackages (ps: with ps; [
          # 利用するパッケージ

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
