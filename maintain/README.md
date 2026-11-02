# Server setup

VPS configuration for rstm.me and related apps.

## Files

- `docker-compose.yaml` → `/root/docker-compose.yaml` — all services: traefik (reverse proxy + Let's Encrypt), rstm, life, timer, wishlist, intervals-bridge, intervals-mcp, google-health-mcp, watchtower (auto-updates); health-sync runs from cron under the `jobs` profile
- `daemon.json` → `/etc/docker/daemon.json` — container log rotation (10m × 3 files) and `live-restore` (containers survive docker daemon restarts)
- `health-sync.service`, `health-sync.timer` → `/etc/systemd/system/` — hourly run of the health-sync job (compose `jobs` profile); logs: `journalctl -u health-sync`
- `default.conf` — nginx config used inside the rstm image

## Apply

```sh
# compose services
docker compose -f /root/docker-compose.yaml up -d

# hourly health-sync job
cp health-sync.service health-sync.timer /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now health-sync.timer

# docker daemon config (log limits apply to newly created containers)
cp daemon.json /etc/docker/daemon.json
systemctl restart docker

# cap systemd journal size
sed -i 's/^#\?SystemMaxUse=.*/SystemMaxUse=200M/' /etc/systemd/journald.conf
systemctl restart systemd-journald
```
