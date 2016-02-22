with import <nixpkgs> {};

(python2.buildEnv.override {
 extraLibs = with python2Packages;
 [ 
   # Used python3 packages
   # python3 packages can be listed with 
   # nix-env -f "<nixpkgs>" -qaP -A python2Packages

 ];
}).env
