
## docker run postgres

```bash
docker run -d --restart unless-stopped  --name perf-postgres  -e POSTGRES_PASSWORD=Aiperf@2025  -e PGDATA=/var/lib/postgresql/data/pgdata  -v /opt/postgresql:/var/lib/postgresql/data   postgres:12-alpine
```