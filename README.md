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

## Nix Shells

`nix-shell`はカスタムシェル環境を起動するコマンド。
そのカスタムシェルに好きなパッケージを利用できます。

Nix Shellファイルを`shell.nix`または`default.nix`にファイル名変更をすると自動的に読み込まれます。

* [Haskell開発](nix-shells/haskell.nix)
