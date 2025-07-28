# Photon + Nominatim Docker Setup

This repository provides a Docker-based deployment of [Photon](https://photon.komoot.io/) (geocoding search engine) with [Nominatim](https://nominatim.org/) (OpenStreetMap geocoding service) using Hungary OSM data.

## Services

- **Nominatim**: PostgreSQL-based geocoding service (port 8081)
- **Photon**: Elasticsearch-based geocoding search engine (port 2322)

## Quick Start

### 1. Start Services

```bash

git clone https://github.com/drifteaur/nominatim-photon

docker compose up -d

# wait for nomitatim to populate

docker compose down

# delete the photon data volume, keep the nominatim volume

docker volume ls
docker volume rm nominatim-photon_photon-data

docker compose up -d

# photon will populate itself
```

### 2. Wait for Initialization

Services need time to initialize, especially on first run:
- Nominatim loads Hungary OSM data and sets up PostgreSQL
- Photon imports data from Nominatim and builds Elasticsearch index

Monitor logs until both services are ready:
```bash
docker-compose logs -f nominatim
docker-compose logs -f photon
```

### 3. Test Services

**Test Nominatim** (JSON format):
```bash
curl "http://localhost:8081/search?q=Budapest&format=json&limit=1"
```

**Test Photon** (GeoJSON format):
```bash
curl "http://localhost:2322/api?q=Budapest&lang=hu"
```

## Service Management

```bash
# Stop services
docker-compose down

# Rebuild Photon container after changes
docker-compose build photon
docker-compose up -d photon

# View specific service logs
docker-compose logs -f nominatim
docker-compose logs -f photon
```

## API Examples

### Nominatim API

Search for places:
```bash
# Basic search
curl "http://localhost:8081/search?q=Szeged&format=json"

# Reverse geocoding
curl "http://localhost:8081/reverse?lat=47.4979&lon=19.0402&format=json"

# Structured search
curl "http://localhost:8081/search?city=Budapest&country=Hungary&format=json"
```

### Photon API

Search with various parameters:
```bash
# Basic search
curl "http://localhost:2322/api?q=Debrecen"

# Search with language preference
curl "http://localhost:2322/api?q=Pécs&lang=hu"

# Limit results
curl "http://localhost:2322/api?q=Budapest&limit=5"

# Search near coordinates
curl "http://localhost:2322/api?q=restaurant&lat=47.4979&lon=19.0402"
```

## Data Coverage

This setup uses **Hungary** OSM data from [Geofabrik](https://download.geofabrik.de/europe/hungary.html):
- Source: `https://download.geofabrik.de/europe/hungary-latest.osm.pbf`
- Updates: `https://download.geofabrik.de/europe/hungary-updates/`

## Architecture

- **Nominatim**: Uses MediaGIS Nominatim 4.4 Docker image
- **Photon**: Custom build using Photon 0.5.0 with OpenJDK 8
- **Data**: Persistent volumes for both PostgreSQL and Elasticsearch data
- **Network**: Services communicate internally via Docker network

## Official Resources

### Nominatim
- **Website**: https://nominatim.org/
- **GitHub**: https://github.com/osm-search/Nominatim
- **API Documentation**: https://nominatim.org/release-docs/latest/api/Search/
- **Docker Image**: https://github.com/mediagis/nominatim-docker

### Photon
- **Website**: https://photon.komoot.io/
- **GitHub**: https://github.com/komoot/photon
- **API Documentation**: https://github.com/komoot/photon#search-api
- **Demo**: https://photon.openstreetmap.fr/

## Troubleshooting

### Services won't start
- Check if ports 8081 and 2322 are available
- Remove conflicting containers: `docker rm nominatim`
- Clear volumes if needed: `docker-compose down -v`

### No search results
- Ensure services have fully initialized (check logs)
- Verify you're searching for places in Hungary
- Try different search terms or formats

### Performance issues
- First-time startup can take 10-15 minutes for data import
- Subsequent starts are much faster using persistent volumes
- Monitor system resources during initial setup
