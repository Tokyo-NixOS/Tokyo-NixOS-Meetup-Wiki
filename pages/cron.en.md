# Cron

## Setting environment in crontabs

To have access to programs, the path variable should be set to match nixos specific locations on the first line of the crontab file:

```cron
PATH=/run/current-system/sw/bin:/run/current-system/sw/sbin:/usr/bin:~/.nix-profile/bin

*/5 * * * *   mbsync -a
```
