with import <nixpkgs> {};

(python3.buildEnv.override {
 extraLibs = with python3Packages;
 [ 
   # Used python3 packages
   # python3 packages can be listed with 
   # nix-env -f "<nixpkgs>" -qaP -A python3Packages

 ];
}).env
