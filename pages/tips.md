# Tips

## コマンド

### nix-storeが大きすぎ

rootユーザで下記のコマンドを実行すれば、古い利用されていないパッケージが削除されます。
`14d`は14日と意味し、14日以上の利用されていないパッケージをすべて削除します。（数十ギガを取り戻す事もあります）

```$
$ nix-collect-garbage --delete-older-than 14d
```

### パッケージを試す

`nix-shell`で簡単にパッケージを試す事ができます。

```shell
$ nix-shell -p qutebrowser
$ qutebrowser
```

※ `-p`の後に複数のパッケージを指定できます。

### 楽にパッケージを検索とインストール

`nox`は`nix-env`より簡単でわかりやすくパッケージをインストールと検索できます。

```
$ nox browser
```

## `configuration.nix`

### カーネルバージョンを変更

  ``nix
  boot = {
    kernelPackages = pkgs.linuxPackages_4_1;
  };
```

利用できるカーネルは

```bash
$ nix-env -qaP 'linux'
```

### トラックバックの設定

```nix
  services = {
    xserver = {
      synaptics.enable = true;
      synaptics.twoFingerScroll = true;
    };
  };
```

### configuration.nixを分散


```nix
  imports = [ 
    ./hardware-configuration.nix
    ./fonts.nix
  ];
```

/etc/nixos/fonts.nix


```nix
{ config, lib, pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [ 
      ipafont
      powerline-fonts
      baekmuk-ttf
      kochi-substitute
      carlito
    ];

    fontconfig = { 
      defaultFonts = {
        monospace = [ 
          "DejaVu Sans Mono for Powerline"
          "IPAGothic"
          "Baekmuk Dotum"
        ];
        serif = [ 
          "DejaVu Serif"
          "IPAPMincho"
          "Baekmuk Batang"
        ];
        sansSerif = [
          "DejaVu Sans"
          "IPAPGothic"
          "Baekmuk Dotum"
        ];
      };
    };
  };
}
```

### プリンターとスキャナー

プリンター(HPプリンターの例、別なプリンターには別なドライバーが必要)

```nix
  services = {
    printing = {
      enable  = true;
      drivers = [ pkgs.hplip ];
    };
  };
```

スキャナー(HPプリンターの例、別なプリンターには別なドライバーが必要)

```nix
  hardware = {
    pulseaudio.enable = true;
    sane.enable = true;
    sane.extraBackends = [ pkgs.hplipWithPlugin ];
  };
```





