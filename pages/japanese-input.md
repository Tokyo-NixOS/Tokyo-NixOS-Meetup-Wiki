# 日本語入力を設定

`/etc/nixos/configuration.nix` に下記の設定を追加

```nix
{ config, pkgs, ... }:
{
  ...
  programs = {
    ibus.enable = true;
    ibus.plugins = [ pkgs.ibus-anthy pkgs.mozc ];
  };
  ...
}
```

日本語入力環境を改善する開発中の[PR](https://github.com/NixOS/nixpkgs/pull/11254)があります。
手伝える方はぜひissue等で連絡してください。
