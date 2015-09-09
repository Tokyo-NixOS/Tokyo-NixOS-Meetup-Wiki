# Tokyo Nixos Meetup Wiki

## 日本語入力を有効

`/etc/nixos/configuration.nix` に下記の設定を追加

~~~~
{ config, pkgs, ... }:
{
  ...
  programs = {
    ibus.enable = true;
    ibus.plugins = [ pkgs.ibus-anthy pkgs.mozc ];
  };
  ...
}
~~~~


