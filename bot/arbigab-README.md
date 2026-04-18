# Gabagool Arbitrage Bot - Deployment Guide

## Quick Start

### 1. Prerequisites
- Docker and Docker Compose installed on your machine

### 2. Setup

**Load the image file you received:**
```bash
docker load -i arbigab-image.tar
```
### 4. Run

```bash
docker compose up -d
```

The dashboard will be available at: **http://your-server-ip:8080**

### 5. Manage

```bash
# View logs
docker compose logs -f

# Stop
docker compose down

# Restart
docker compose restart
```

### Changing the Port

To use a different port (e.g. 9090), edit `docker-compose.yml`:
```yaml
ports:
  - "9090:8080"
```

Need help? Visit https://gabagool22.com/contact
