# Tado Local Add-on

Home Assistant add-on for managing TADO devices locally via the HomeKit bridge.

## Description

This add-on runs the TadoLocal project, which provides a local REST API for controlling TADO devices without relying on cloud services. It communicates directly with your TADO bridge using the HomeKit protocol. The application source is downloaded at image build time — see `Dockerfile` for the upstream source it pulls.

Supported architectures: `amd64` and `aarch64`. Images are published to
`ghcr.io/vvlasy/tado_local_amd64` and `ghcr.io/vvlasy/tado_local_aarch64`.

## Features

- Local control of TADO devices (no cloud dependency)
- REST API for integration with Home Assistant and other platforms
- Real-time device state updates
- Web interface accessible via Home Assistant Ingress
- Persistent state storage in Home Assistant's config directory

## Installation

1. Add this repository to Home Assistant:
   - Go to **Settings** > **Add-ons** > **Add-on Store**
   - Click the three dots (⋮) in the top right corner
   - Select **Repositories**
   - Add: `https://github.com/VVlasy/hassio-tado-local`
   - Click **Add**

2. Install the add-on:
   - Find "Tado Local" in the Add-on Store
   - Click **Install**
   - Wait for installation to complete

3. Configure the add-on:
   - Click **Configuration** tab
   - Enter your TADO bridge IP address
   - Enter your HomeKit pairing PIN (format: XXX-XX-XXX)
   - Click **Save**

4. Start the add-on:
   - Click **Start**
   - Check the **Log** tab to verify it's running

## Configuration

### Options

| Option | Required | Description |
|--------|----------|-------------|
| `bridge_ip` | Yes | IP address of your TADO bridge on the local network |
| `pin` | Yes | HomeKit pairing PIN (format: XXX-XX-XXX) |
| `event_stale_timeout` | No | Seconds without HomeKit events before the add-on resubscribes, then reconnects (default `3600`, `0` disables). See `patches/`. |

### Finding Your Bridge IP and PIN

1. **Bridge IP**: Check your router's DHCP client list or use a network scanner
2. **PIN**: Found on the bottom of your TADO bridge device (format: XXX-XX-XXX)

## Usage

### Web Interface

The add-on's web interface is accessible via Home Assistant Ingress:
- Click **Open Web UI** button in the add-on panel
- Or access via the add-on's **Ingress** link

The web interface provides:
- Device status and control
- API documentation at `/docs`
- Real-time event stream at `/events`

### REST API

The add-on exposes a REST API on port 4407 (accessible via Ingress). Example endpoints:

- `GET /api/v1/zones` - List all zones
- `GET /api/v1/zones/{zone_id}` - Get zone details
- `POST /api/v1/zones/{zone_id}/set_temperature` - Set temperature
- `GET /api/v1/status` - Get system status

See the interactive API documentation at `/docs` when the add-on is running.

## Data Storage

The add-on stores its database in Home Assistant's config directory:
- Location: `/config/tado_local/tado-local.db`
- This ensures data persistence across add-on restarts and updates

## Support

- **Issues**: [GitHub Issues](https://github.com/VVlasy/hassio-tado-local/issues)
- **Source**: the TadoLocal project tarball referenced in this add-on's `Dockerfile`

## License

Apache License 2.0
