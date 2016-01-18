with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name        = "myproject";
  buildInputs = [ rustc cargo ];
  shellHook   = ''
    export PS1="${name}:rust-env> "
  '';
}
