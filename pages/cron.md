# Cron

## crontabでの環境設定

プログラムにアクセスできるように、crontabの頭に「PATH」環境変数を設定するが必要:

```cron
PATH=/run/current-system/sw/bin:/run/current-system/sw/sbin:/usr/bin:~/.nix-profile/bin

*/5 * * * *   mbsync -a
```

グローバルでインストールされたプログラムは`/run/current-system/sw/bin`と`/run/current-system/sw/sbin`に入ります。
ユーザがインストールするプログラムは`~/.nix-profile/bin`に入ります

