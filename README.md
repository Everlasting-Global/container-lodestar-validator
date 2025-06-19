# Container Lodestar Validator

A custom Docker container for running Lodestar Ethereum validators with enhanced configuration options and automated key management.

## Overview

This repository provides a containerized solution for running Lodestar validators with support for:

- Automated validator key import
- Builder API integration for MEV-boost
- Distributed validator operation
- Configurable metrics and networking
- Flexible deployment options

## Architecture

The container is built on top of the official Chainsafe Lodestar image and includes a custom startup script (`run.sh`) that handles:

1. **Key Management**: Automatic import of validator keystores from `/opt/data/validator_keys/`
2. **Builder API Integration**: Support for MEV-boost via builder API
3. **Distributed Operation**: Optional distributed validator operation
4. **Metrics**: Built-in Prometheus metrics endpoint
5. **Configuration**: Environment-based configuration management

## Workflow

### 1. Container Build

The container is built using `Dockerfile.template` which:

- Uses the official Lodestar image as base
- Copies the custom `run.sh` script
- Sets the script as the entrypoint

### 2. Startup Process

The `run.sh` script performs the following steps:

1. **Configuration Setup**:
   - Sets default values for builder selection, key import, and distributed mode
   - Overrides builder selection if builder API is enabled

2. **Key Import** (if `IMPORT_KEYS=true`):
   - Scans for keystore files in `/opt/data/validator_keys/`
   - Imports each keystore with its corresponding password file
   - Password files should be named `keystore-*.txt` (matching the keystore JSON files)

3. **Validator Launch**:
   - Starts the Lodestar validator with configured parameters
   - Supports both distributed and standalone modes
   - Enables metrics on port 5064

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `NETWORK` | Required | Ethereum network (mainnet, goerli, sepolia, etc.) |
| `BEACON_NODE_ADDRESS` | Required | Comma-separated list of beacon node addresses |
| `BUILDER_API_ENABLED` | false | Enable builder API for MEV-boost |
| `BUILDER_SELECTION` | executiononly | Builder selection strategy |
| `IMPORT_KEYS` | true | Whether to import validator keys on startup |
| `DISTRIBUTED` | true | Enable distributed validator operation |
| `FEE_RECIPIENT` | - | Ethereum address for fee recipient (non-distributed mode) |
| `GRAFFITI` | - | Graffiti string for block proposals (non-distributed mode) |

### Volume Mounts

- `/opt/data`: Data directory containing validator keys and state
- `/opt/data/validator_keys/`: Directory for keystore files

### Ports

- `5064`: Metrics endpoint (Prometheus format)

## Usage

### Basic Usage

```bash
docker run -d \
  -e NETWORK=mainnet \
  -e BEACON_NODE_ADDRESS=http://beacon:5052 \
  -v /path/to/validator/data:/opt/data \
  your-registry/container-lodestar-validator:latest
```

### With Builder API (MEV-boost)

```bash
docker run -d \
  -e NETWORK=mainnet \
  -e BEACON_NODE_ADDRESS=http://beacon:5052 \
  -e BUILDER_API_ENABLED=true \
  -v /path/to/validator/data:/opt/data \
  your-registry/container-lodestar-validator:latest
```

### Standalone Mode (Non-distributed)

```bash
docker run -d \
  -e NETWORK=mainnet \
  -e BEACON_NODE_ADDRESS=http://beacon:5052 \
  -e DISTRIBUTED=false \
  -e FEE_RECIPIENT=0x1234567890123456789012345678901234567890 \
  -e GRAFFITI="My Validator" \
  -v /path/to/validator/data:/opt/data \
  your-registry/container-lodestar-validator:latest
```

## Key Management

### Keystore Files

Place your validator keystore files in `/opt/data/validator_keys/` with the naming convention:

- Keystore: `keystore-*.json`
- Password: `keystore-*.txt` (same base name as keystore)

### Example Structure

```
/opt/data/validator_keys/
├── keystore-0x1234...abcd.json
├── keystore-0x1234...abcd.txt
├── keystore-0x5678...efgh.json
└── keystore-0x5678...efgh.txt
```

## Building the Container

1. Replace `LODESTAR_VERSION` in `Dockerfile.template` with the desired version
2. Build the container:

   ```bash
   docker build -f Dockerfile.template -t container-lodestar-validator .
   ```

## Monitoring

The validator exposes metrics on port 5064 in Prometheus format. You can access them at:

```txt
http://container-ip:5064/metrics
```

## Troubleshooting

### Common Issues

1. **Key Import Failures**: Ensure password files exist and match keystore names
2. **Network Connectivity**: Verify beacon node addresses are accessible
3. **Permission Issues**: Ensure proper file permissions on mounted volumes

### Logs

Check container logs for detailed error messages:

```bash
docker logs <container-name>
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request
