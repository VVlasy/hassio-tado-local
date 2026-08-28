# Home Assistant Add-on: Tado Local

[![GitHub Release][releases-shield]][releases]
[![License][license-shield]](LICENSE)

Home Assistant add-on repository for TadoLocal - a local REST API for managing
TADO devices via the HomeKit bridge.

> This is a maintained fork of an upstream add-on repository that no longer
> publishes working images. The add-on itself is unchanged; this fork exists to
> build and publish the container images for the architectures listed below.

## About

This repository provides a Home Assistant add-on that runs the TadoLocal project, enabling local control of TADO devices without cloud dependencies. The add-on communicates directly with your TADO bridge using the HomeKit protocol.

Note that this repository contains packaging only. The TadoLocal application
source is downloaded at Docker build time — see `tado_local/Dockerfile` for the
exact upstream source it pulls.

## Features

- 🏠 **Local Control**: No cloud dependency - all communication happens on your local network
- 🔌 **REST API**: Full REST API for integration with Home Assistant and other platforms
- 📊 **Real-time Updates**: Server-Sent Events (SSE) for real-time device state
- 🌐 **Web Interface**: Served on port 4407
- 💾 **Persistent Storage**: State stored in Home Assistant's config directory
- 🐳 **Multi-Architecture**: `amd64` and `aarch64`

## Supported architectures

| Architecture | Supported | Image |
|---|---|---|
| `amd64` | ✅ | `ghcr.io/vvlasy/tado_local_amd64` |
| `aarch64` | ✅ | `ghcr.io/vvlasy/tado_local_aarch64` |
| `armv7` / `armhf` / `i386` | ❌ | not built |

32-bit architectures are deliberately not built: there are no native runners for
them and 32-bit musl has no prebuilt `cryptography` wheels, so those builds
compile Rust under emulation and time out.

## Installation

1. In Home Assistant, go to **Settings** > **Add-ons** > **Add-on Store**
2. Click the three dots (⋮) in the top right corner
3. Select **Repositories**
4. Add this repository URL: `https://github.com/VVlasy/hassio-tado-local`
5. Click **Add**
6. Find "Tado Local" in the Add-on Store and install it

If you previously added the upstream repository, remove it first and uninstall
the old add-on — otherwise Home Assistant may keep resolving the add-on to the
upstream images, which are not published.

Images are pulled from the GitHub Container Registry under
`ghcr.io/vvlasy/`. They must be **public** for Home Assistant to install the
add-on; the Supervisor pulls anonymously, and a private package produces the
same `[404] manifest unknown` error as a missing one.

## Configuration

The add-on requires two configuration options:

- **bridge_ip**: IP address of your TADO bridge on the local network
- **pin**: HomeKit pairing PIN (format: XXX-XX-XXX, found on the bottom of your bridge)

## Usage

### Web Interface

Access the web interface from the add-on panel:
- Click **Open Web UI** in the add-on panel
- Or browse directly to `http://<home-assistant-host>:4407/`

The web interface provides:
- Device status and control
- Interactive API documentation at `/docs`
- Real-time event stream at `/events`

### REST API

The add-on exposes a REST API on port 4407. Key endpoints:

- `GET /api/v1/zones` - List all zones
- `GET /api/v1/zones/{zone_id}` - Get zone details
- `POST /api/v1/zones/{zone_id}/set_temperature` - Set temperature
- `GET /api/v1/status` - Get system status

See the interactive API documentation at `/docs` for complete endpoint details.

## Architecture

```
┌─────────────────┐
│  Tado Bridge    │ ←─── HomeKit Protocol (local)
│  (HomeKit)      │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  Tado Local     │ ←─── This Add-on
│  (REST API)     │
└────────┬────────┘
         │
         ├──→ Home Assistant (port 4407)
         └──→ SQLite Database (/config/tado_local/tado-local.db)
```

## Development

### Building

`.github/workflows/release.yml` builds and pushes the images on any pushed `v*`
tag. One job per architecture, one image name per architecture — the Supervisor
resolves `image: ghcr.io/vvlasy/tado_local_{arch}` to a separate
`_amd64` / `_aarch64` repository, so a single multi-arch manifest would not work
here.

The workflow first checks that the `version:` in `tado_local/config.yaml`
matches the pushed tag (minus a leading `v`) and fails the run if they diverge.

Releasing:

```bash
# version in tado_local/config.yaml must match the tag without the leading v
git tag v0.0.1-alpha.10
git push origin v0.0.1-alpha.10
```

### Local Testing

To test the add-on locally:

1. Clone this repository
2. Build the Docker image:
   ```bash
   docker build -t tado_local:test -f tado_local/Dockerfile --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base-python:3.14-alpine3.23 tado_local/
   ```
3. Run the container with proper volume mounts

## Repository Structure

```
hassio-tado-local/
├── .github/
│   └── workflows/
│       └── release.yml         # Image build + release pipeline
├── tado_local/
│   ├── config.yaml             # Add-on manifest
│   ├── Dockerfile              # Docker image definition
│   ├── run.sh                  # Startup script
│   └── README.md               # Add-on documentation
├── repository.json             # Repository metadata
└── README.md                   # This file
```

## Requirements

- Home Assistant (Supervised, OS, or Container installation) on `amd64` or `aarch64`
- TADO bridge device on your local network
- HomeKit pairing PIN from your TADO bridge

## Support

- **Issues**: [GitHub Issues](https://github.com/VVlasy/hassio-tado-local/issues)

Issues with this fork's packaging belong here. Issues with the TadoLocal
application itself belong in the upstream project linked from
`tado_local/Dockerfile`.

## License

Apache License 2.0 - see [LICENSE](LICENSE) file for details.

[releases-shield]: https://img.shields.io/github/release/VVlasy/hassio-tado-local.svg
[releases]: https://github.com/VVlasy/hassio-tado-local/releases
[license-shield]: https://img.shields.io/github/license/VVlasy/hassio-tado-local.svg
