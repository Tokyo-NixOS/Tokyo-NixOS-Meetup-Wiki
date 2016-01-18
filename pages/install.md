# NixOSのインストール

英語を読める方はぜひ一度公式インストールマニュアルに目を通してください。 -> [公式マニュアル](https://nixos.org/nixos/manual/index.html#sec-installation)

公式ページから最新のISOファイルをダウンロードします。 -> [ダウンロードページ](http://nixos.org/nixos/download.html)。

このチュートリアルはMinimal Installation CDを使う前提です。

CDで起動したら、Grub画面が表示されます。そこで「NixOS <バージョン> Installer」を選択したままエンターキーを押します。

ブートが終わりましたら、プロンプトが表示されます。
この状態ではいつでも「alt+F8」でマニュアルを表示することができます。（「alt+F1」を押せばプロンプトに戻れます）

プロンプトで最初に行いたい事はキーボードレイアウトを日本語レイアウトに変更することです。

```shell
loadkeys jp106
```

## パーティショニング

NixOSのインストールにでは「fdisk」や「gdisk」を利用して手動でパーティショニングを行います。
パーティショニングは複雑なトピックであります。

NixOSのソフトウェアはすべて「/nix/store/」にインストールされます。OSのデザインから「/nix/store/」が大きいなるので、十分な領域を与えたいです。(50ギガ以上は無難)

パーティショニングを行う前にArchlinuxの[パーティショニング](https://wiki.archlinuxjp.org/index.php/パーティショニング)Wikiページを読むのを勧めます。

MBRとGPTのに種類のパーティションがあります。簡単にまとめると

* UEFIシステムはGPTを使わないといけない
* GPTで`grub`を利用できません（その代わりgummibootを使います）

詳しくはArchlinuxのWikiを参考にしてください。-> [GPT か MBR の選択](https://wiki.archlinuxjp.org/index.php/パーティショニング#GPT_.E3.81.8B_MBR_.E3.81.AE.E9.81.B8.E6.8A.9E)

参考までに自マシンのパーティショニングは（1Tのハードディスク）

* `/dev/sda1`に`/boot`を512M 
* `/dev/sda2`にswapを20G (RAMは16G)
* `/dev/sda3`に`/`を100G 
* `/dev/sda4`に`/home`の残りの810.5G

### MBR

まずはfdiskで利用できるディスクを確認します。

```shell
fdisk -l
```

一つのハードディスクがある場合はすべてのディスクがリストされます。一つのハードディスクがある場合は「/dev/sda」がリストアップされるはず。

次はfdiskでパーティションを作ります。

```
fdisk /dev/sda
```

fdiskからパーティションを作ります。下記はあくまで参考のための例となります。
利用しているPCによって調整が必要となります。

* `o` を入力して、`enter`キーを押します（パーティションテーブルを作成）

`boot`パーティション作成(任意)

* `n`を入力して、`enter`キーを押します(パーティションを新しく作る)
* `p`を入力して、`enter`キーを押します(種類をprimary)
* `enter`キーを押します(パーティション番号、デフォルトのまま)
* `enter`キーを押します(初めてのセクター、デフォルトのまま)
* `+200M`を入力して、`enter`キーを押します（サイズ設定、bootは100M以上がおすすめ)

`swap`パーティション作成(任意)

* `n`を入力して、`enter`キーを押します(パーティションを新しく作る)
* `p`を入力して、`enter`キーを押します(種類をprimary)
* `enter`キーを押します(パーティション番号、デフォルトのまま)
* `enter`キーを押します(初めてのセクター、デフォルトのまま)
* `+8G`を入力して、`enter`キーを押します（サイズ設定、PCのメモリによります [参考ページ](https://help.ubuntu.com/community/SwapFaq#How_much_swap_do_I_need.3F))
* `t`を入力して、`enter`キーを押します(パーティション種類変更)
* `2`を入力して、`enter`キーを押します(今作ったパーティション)
* `82`を入力して、`enter`キーを押します(swapに設定)


`/`パーティションの作成

* `n`を入力して、`enter`キーを押します(パーティションを新しく作る)
* `p`を入力して、`enter`キーを押します(種類をprimary)
* `enter`キーを押します(パーティション番号、デフォルトのまま)
* `enter`キーを押します(初めてのセクター、デフォルトのまま)
* `enter`キーを押します(残り領域をすべて利用する)

* `p`を入力して、`enter`キーを押して、パーティションテーブルを確認します

問題がなければ

* `w`を入力して、`enter`キーを押して、パーティションテーブルを記録します

パーティショニングはこれで終わりました！
新しく出来たパーティションは`fdisk -l`で確認できます。

### GPT

TODO

## ファイルシステム

NixOSではいろいろなファイルシステムを利用できます。どれを利用すれば良いのわからない場合は`ext4`が無難です。

前のパーティショニング通りにしていれば、

* `/dev/sda1`はブート用
* `/dev/sda2`はswap用
* `/dev/sda3`は/用

では早速ファイルシステムを作ります

```bash
mkfs.ext4 -L boot /dev/sda1
```

```bash
mkswap /dev/sda2
```

```bash
mkfs.ext4 -L nixos /dev/sda3
```

## パーティショニングをマウント

まずは/をマウントします

```bash
$ mount /dev/disk/by-label/nixos /mnt
```

次はbootフォルダーを作ります

```bash
$ mkdir /mnt/boot
```

でブートをマウントします。


```bash
$ mount /dev/disk/by-label/boot /mnt/boot
```

最後にswapを有効にします

```bash
$ swapon /dev/sda2
```

## ネットワーク

インストールにはネットワークが必要です。
優先で接続していれば自動的にネットワークが設定されます。

ネットワークを試すには`ping`コマンドを使えます。

```bash
$ ping nixos.org
```

### Wifi

TODO

## 設定

NixOSの設定ファイルを生成します。

```bash
$ nixos-generate-config --root /mnt
```

このコマンドでファイルは2つ生成されます

* `/mnt/etc/nixos/hardware-configuration.nix`
* `/mnt/etc/nixos/configuration.nix`

`/mnt/etc/nixos/hardware-configuration.nix`は変更が必要ないが、`less`等で確認するには損がない。
`hardware-configuration.nix`にはカーネルモジュールとファイルシステムが設定されています。

`configuration.nix`はメインの設定ファイルとなります。
インストール段階では*必ず*変更しないといけないです。

エディターは`nano`しか入っていないので、vim派の人は

```bash
nix-env -i vim
```

emacs派の人は

```bash
nix-env -i emacs
```

のコマンドで好きなエディターを利用できます。(ネットワーク必要)

で`configuration.nix`を編集しましょう。
`configuration`はNixOSのメインの設定ファイルであって、変更する事でシステムのいろいろをカスタマイズできます。

Nix言語で書かれていて、オプションがいろいろあります。
公式サイトでオプションを検索できます。[オプションページ](http://nixos.org/nixos/options.html)。

またコマンドラインでも探せます。

```shell
$ nixos-option networking.hostName
Value:
"nixos"

Default:
"nixos"

Description:

The name of the machine. Leave it empty if you want to obtain
it from a DHCP server (if using DHCP).

Declared by:
  "/nix/store/0q3jj4lqvvl4b330jfnwh56jjcm823m3-nixos-16.03pre75064.faae09f/nixos/nixpkgs/nixos/modules/tasks/network-interfaces.nix"

Defined by:
  "/nix/store/0q3jj4lqvvl4b330jfnwh56jjcm823m3-nixos-16.03pre75064.faae09f/nixos/nixpkgs/nixos/modules/tasks/network-interfaces.nix"
```

この時点で必要な設定は`boot.loader.grub.device`、デフォルトではコメントアウトされていますのでコメントアウトを外しましょう。
`/dev/sda`はパーティションをセットアップしたディスクを指定する、`/dev/sda`ディスク以外にパーティションを作った場合は設定の変更が必要です。（この設定は有効でないとgrubはインストールされず、ブートはできません）

```nix
  boot.loader.grub.device = "/dev/sda";
```

ついでにホスト名を設定しましょう

```nix
  networking.hostName = "nixos";
```

Wifiを使う場合は`networking.wireless.enable`を有効にします

```nix
  networking.wireless.enable = "true";
```

国際化も設定しましょう

```nix
  i18n = {
    consoleFont   = "lat2-Terminus16";
    consoleKeyMap = "jp106";
    defaultLocale = "ja_JP.UTF-8";
  };

  time.timeZone = "Asia/Tokyo";
```

X11やデスクトップ環境を設定する場合は下記のように設定すれば良いです

### Xmonad

```nix

  services = {
    xserver = {
      enable = true;
      # X11で日本語キーボード
      layout = "jp";
      windowManager.xmonad.enable = true;
      windowManager.xmonad.enableContribAndExtras = true;
      windowManager.default = "xmonad";
      desktopManager.default = "none";
      desktopManager.xterm.enable = false;
    };
  };
```

### KDE

```nix

  services = {
    xserver = {
      enable = true;
      # X11で日本語キーボードレイアウト
      layout = "jp";
      displayManager.kdm.enable = true;
      desktopManager.kde4.enable = true;
    };
  };
```

ユーザ作成も`configuration.nix`でできます。
`users.extraUsers`の後に来るのはユーザ名となります。

```nix
  # fooを好きなユーザ名に変更
  users.extraUsers.foo = {
    isNormalUser = true;
    # homeディレクトリを作る
    createHome   = true;
    uid          = 1000;
  };
```

## インストール

ようやくインストールできます

```nix
$ nixos-install
```

最後に新しいシステムのrootパスワード頼まれます。
うまく設定できなかった場合はもう一度`nixos-install`を実行しましょう。

終わったら、パソコンを一同しましょう

```
$ poweroff
```

消した後はCDやインストールUSBを外してから起動しましょう。

再起動しましたら、設定した環境のログインもしくはプロンプトのログインが出ます。

`configuration.nix`でユーザを作ってX11環境を利用場合は、そのユーザのパスワードが設定されていないので、`ctrl + alt + F2`で別なバーチャルコンソールで`root`としてログインし、`passwd`コマンドでパスワードを設定しましょう。

```
$ passwd foo
```

で`exit`コマンドでログアウトします。

```
$ exit
```

`ctrl + alt + F7`でX11のバーチャルコンソールに戻り、`configuration.nix`で設定したユーザでログインできます！


