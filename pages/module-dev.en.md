# Developing NixOS Modules

Customizing modules is a little more complicated than customizing packages.

## 1/ Getting stable nixpkgs

Development is very active on nixpgs main repository so trying to rebuild the configuration on it can trigger massive source building.

To avoid that, it is possible to use a nixpkgs version that is at the same state as nix channels to use the binary cache.

The first thing to do is to clone the `[nixpgs-channel](https://github.com/NixOS/nixpkgs-channels) repository:

~~~~
# git clone git@github.com:NixOS/nixpkgs-channels.git
~~~~

Then, checkout the branch corresponding to the system channel.

To know the system channel, as root run:

~~~~
# nix-channel --list
~~~~

sample output:

~~~~
nixos https://nixos.org/channels/nixos-unstable
~~~~

The last part of the url, in this case `nixos-unstable` is the system channel.

To checkout the branch the you can run the following command from the folder where `nixpkgs-channels` has been cloned.

~~~~
# git checkout nixos-unstable
~~~~

or

~~~~
# git checkout nixos-15.09
~~~~

depending the channel used.

## 2/ Sync the channels

The system channel and the git repository should be up to date before hacking

To update the system channel, as root run:

~~~~
# nixos-rebuild switch --upgrade
~~~~

This will update the channel, all the configuration options and the packages.

Then we have to update the nixpkgs-channel repository:

~~~~
# git pull
~~~~

## 3/ Hacking

Configuration modules are located under `nixos/modules`.

To test the changes, as root run:

~~~~
nixos-rebuild -I nixpkgs=<path> switch
~~~~

where `<path>` should be the full path to the local `nixpgs-channel`, for example:

~~~~
nixos-rebuild -I nixpkgs=/home/nix-user/Projects/nixos/nixpkgs-channels/ switch
~~~~

If something goes wrong, it is possible to rollback:

~~~~
nixos-rebuild switch --rollback
~~~~

## 4/ Publishing the changes to nixpkgs (optional)

In case the changes can benefit to all users, it is a good idea to send a pull request to [nixpkgs](https://github.com/NixOS/nixpkgs).

Fork and clone locally [nixpkgs](https://github.com/NixOS/nixpkgs), details in [github forking guide](https://guides.github.com/activities/forking/).

then generate a patch file from the changed nixpgs-channel repository:

~~~~
# git diff > /tmp/my.patch
~~~~

Then from the forked nixpkgs repository, create a branch and apply the patch:

~~~~
# git checkout -b my-branch
# patch -p1 < /tmp/my.patch
~~~~

Be sure to follow naming convention for the commit and pull request from the [contributor guide](http://nixos.org/nixpkgs/manual/#chap-submitting-changes).

Commit and send the pull request from github.
