# Server setup

VPS configuration for rstm.me and related apps.

## Files

- `docker-compose.yaml` → `/root/docker-compose.yaml` — all services: traefik (reverse proxy + Let's Encrypt), rstm, life, timer, wishlist, intervals-bridge, watchtower (auto-updates)
- `daemon.json` → `/etc/docker/daemon.json` — container log rotation (10m × 3 files) and `live-restore` (containers survive docker daemon restarts)
- `default.conf` — nginx config used inside the rstm image

## Apply

```sh
# compose services
docker compose -f /root/docker-compose.yaml up -d

# docker daemon config (log limits apply to newly created containers)
cp daemon.json /etc/docker/daemon.json
systemctl restart docker

# cap systemd journal size
sed -i 's/^#\?SystemMaxUse=.*/SystemMaxUse=200M/' /etc/systemd/journald.conf
systemctl restart systemd-journald
```
