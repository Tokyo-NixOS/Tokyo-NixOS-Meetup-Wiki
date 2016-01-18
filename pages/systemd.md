# SystemD

## Cronの代わりにsystemd timerを使う


```nix
  systemd.user = { 

    services = {
      mbsync = {
        description = "mailbox sync";
        after       = [ "network-online.target" ];
        wantedBy    = [ "default.target" ];
        path        = [ pkgs.isync ];
        script      = ''mbsync -a'';
      };
    };

    timers = {
      mbsync = {
        timerConfig = {
          OnUnitInactiveSec = "5min";
          Persistent = "true";
        };
        wantedBy = [ "timers.target" ];
      };
    };

  };
```

```
systemctl --user enable mbsync.timer
systemctl --user start mbsync.timer
```
