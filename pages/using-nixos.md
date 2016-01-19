# 日々のお手入れ

## パッケージの検索

`nix-env`コマンドでパッケージを検索できます。

```shell
$ nix-env -qaP 'firefox'
```

正規表現も使えます


```shell
$ nix-env -qaP 'fire.*'
```

`nox`というパッケージ検索インストールヘルパーがあります。
`nix-env`よりは使いやすいのでメインで使うのはおすすめです。

```shell
$ nox firefox
```

## パッケージのインストール

Nixではマルチユーザパッケージインストールが可能のため、パッケージインストールには2つの方法があります。

NixOSの宣言型設定を活かすやシングルユーザの場合はシステムプロフィールにインストールがおすすめです。

### ユーザプロフィールに

一般Linuxディストリビューションと同様にコマンドを実行してパッケージをインストールする。

```shell
$ nix-env -i firefox
```

- メリット: 一般ユーザがインストールできる
- デメリット: 宣言型ではない

### システムプロフィールに(NixOSのみ)

`/etc/nixos/configuration.nix`でシステムレベルでインストールするパッケージを指定できます。
該当設定項目は`environment.systemPackages`となります。

```nix
  environment.systemPackages = with pkgs; [
    firefox
    termite
    wget
  ];
```

パッケージを追加した後は`nixos-rebuild switch`で設定を適用し、パッケージをインストールします。

```shell
$ nixos-rebuild switch
```

- メリット: root権限が必要
- デメリット: 宣言型である

## パッケージのアップデート

NixはNixストアで利用しているチャンネルに合っているnixpkgsをもっていますので、
パッケージアップデートをするは2ステップです。

1. チャンネルをアップデートして、ストア内のnixpkgsをアップデートする
2. パッケージをアップデートする

### チャンネルをアップデート

```shell
$ nix-channel --update
```

チャンネルはグローバルとユーザにそれぞれ定義されています。
利用チャンネルを確認するには

```shell
$ nix-channel --list
```

### パッケージのアップデート

ユーザパッケージは  

```shell
$ nix-env -u
```

グローバルパッケージは

```shell
$ nixos-rebuild switch
```

で更新できます。

※`nixos-rebuild switch`は`configuration.nix`を再評価しますので、パッケージ以外にサービスやモジュールを同時にアップデートします。

## パッケージを試す

`nix-shell`で簡単にパッケージを試す事ができます。

```shell
$ nix-shell -p qutebrowser
$ qutebrowser
```

※ `-p`の後に複数のパッケージを指定できます。

## パッケージの削除

Nixの構造関係で直接にパッケージをアンインストールする事はできません。
アンインストールするためにはパッケージをアンリンクしてから、ガーベージコレクションを実行します。

### パッケージのアンリンク

ユーザプロフィールにインストールしたパッケージなら

```shell
$ nix-env -e firefox
```

グローバルプロフィールにインストールされたパッケージは`configuration.nix`の`environment.systemPackages`から削除してから

```shell
$ nixos-rebuild switch
```

### ガーベージコレクション

NixOSのロールバック機能のために以前のプロフィールジェネレーションに利用されているパッケージが必要です。
古いプロフィールジェネレーションを削除することで、NixOSは不要なパッケージを判断して、ストアから削除します。

```shell
$ nix-collect-garbage --delete-older-than 14d
```

`--delete-older-than`の`14d`は14日以上の古いプロフィールジェネレーション削除し、不要パッケージをストアから削除します。

使い方によってNixストアは大きくなりやすいので、定期的にガーベージコレクションを行いたいです。














