# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Docker-based deployment of Photon (geocoding search engine) with Nominatim (OpenStreetMap geocoding service). The setup uses Hungary data from Geofabrik.

## Architecture

The system consists of two Docker services:

1. **Nominatim** (mediagis/nominatim:4.4)
   - PostgreSQL-based geocoding service
   - Runs on port 8081 (mapped from container port 8080)
   - Loads Hungary OSM data from Geofabrik
   - Provides the backend database for Photon

2. **Photon** (custom build)
   - Elasticsearch-based geocoding search engine
   - Built from photon/Dockerfile using OpenJDK 8
   - Runs on port 2322
   - Depends on Nominatim for data import
   - Uses Photon version 0.5.0

## Key Files

- `docker-compose.yml`: Main orchestration file defining both services
- `photon/Dockerfile`: Custom Photon container definition
- `photon/entrypoint.sh`: Initialization script that:
  - Creates Elasticsearch index from Nominatim data on first run
  - Starts Photon server
  - Contains commented-out continuous update logic

## Common Commands

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f
docker-compose logs -f photon
docker-compose logs -f nominatim

# Stop services
docker-compose down

# Rebuild Photon container after changes
docker-compose build photon
docker-compose up -d photon

# Access services
# Nominatim: http://localhost:8081
# Photon: http://localhost:2322
```

## Development Notes

- The Photon entrypoint script checks for existing Elasticsearch data before importing from Nominatim
- Database credentials are hardcoded in entrypoint.sh (user: nominatim, password: terkepeszet)
- Continuous update functionality is commented out in entrypoint.sh (lines 14-29)
- Both services use persistent volumes for data storage