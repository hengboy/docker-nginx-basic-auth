# nginx-basic-auth

---

> Simple Docker image to provide basic authentication for a single other container.

## Quickstart

```bash
docker run -d --name web dockercloud/hello-world
docker run -d -p 80:80 --link web:web --name auth hengboy/nginx-basic-auth
```

Try accessing and logging in with username `hengboy` and password `opensource`.

```bash
# 密码加密
htpasswd -bn hengboy opensource
# 输出的加密密码
hengboy:$apr1$mFAvczmL$GG.LvNbebMDYp/kGGd3fg0
```

## Advanced

```bash
docker run -d \
           -e HTPASSWD='hengboy:$apr1$mFAvczmL$GG.LvNbebMDYp/kGGd3fg0' \
           -e FORWARD_PORT=1337 \
           --link web:web -p 8080:80 \
           --name auth \
           hengboy/nginx-basic-auth
```

> Use single quotes to prevent unwanted interpretation of `$` signs!

## Configuration

- `HTPASSWD` (default: `hengboy:$apr1$mFAvczmL$GG.LvNbebMDYp/kGGd3fg0`): Will be written to the .htpasswd file on launch (non-persistent)
- `FORWARD_PORT` (default: `80`): Port of the **source** container that should be forwarded
- `FORWARD_HOST` (default: `web`): Hostname of the **source** container that should be forwarded
  > The container does not need any volumes to be mounted! Nonetheless you will find all interesting files at `/etc/nginx/*`.
- `READ_TIMEOUT`：read timeout milliseconds

## Multiple Users

Multiple Users are possible by separating the users by newline. To pass the newlines properly you need to use Shell Quoting (like `$'hengboy\nbar'`):

```
docker run -d --link web:web --name auth \
           -e HTPASSWD=$'hengboy:$apr1$mFAvczmL$GG.LvNbebMDYp/kGGd3fg0\ntest:$apr1$LKkW8P4Y$P1X/r2YyaexhVL1LzZAQm.' \
           hengboy/nginx-basic-auth
```

results in 2 users (`hengboy:bar` and `test:test`).

## Troubleshooting

```
nginx: [emerg] host not found in upstream "web" in /etc/nginx/conf.d/auth.conf:80
```

- You need to link the container as `web` (`--link hengboybar:web`)

---

- SSL is unsupported ATM, but might be available in the near future. For now it might be a suitable solution to use another reverse proxy (e.g. `jwilder/nginx-proxy`) that acts as a central gateway. You just need to configure the `VIRTUAL_HOST` env and disable port forwarding.
