# Health Demo

A minimal Flask app with a `/health` endpoint, built to practice Docker's `HEALTHCHECK` instruction.

## What it does
- Serves `GET /health`, which returns `{"status": "ok"}` with HTTP 200
- Runs continuously, unlike a one-shot script, which makes it the right kind of container for health checks
- Listens on `0.0.0.0:5000` so a published port can reach it

## Run it
```bash
docker build -t health-demo .
docker run -d -p 5000:5000 --name health-test health-demo
curl http://localhost:5000/health
```

## Watching the health status
```bash
docker ps
```
The STATUS column shows `(health: starting)` first, then `(healthy)` once the first check passes.

The Dockerfile defines:
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD curl -f http://localhost:5000/health || exit 1
```
To see the failure case, point the check at a path that doesn't exist (for example `/nonexistent`), rebuild and run it. Docker will mark the container `(unhealthy)`, even though the Flask process is still running.

## Notes
- `requirements.txt` is copied and installed **before** `app.py`, so changing the app code doesn't re-run `pip install` (layer caching).
- `curl` is installed in the image because `python:3.12-slim` doesn't include it and the health check needs it.
- The container runs as a non-root user (`appuser`).
- The health check's `curl` runs inside the container, so it needs no `-p` mapping. `-p` is only for reaching the app from outside.