#!/usr/bin/with-contenv bashio

# ==============================================================================
# Home Assistant Add-on: Tado Local
# ==============================================================================

bashio::log.info "Tado Local starting..."

# Get configuration options
BRIDGE_IP=$(bashio::config 'bridge_ip')
PIN=$(bashio::config 'pin')
STATE_DB=$(bashio::config 'state_db')
EVENT_STALE_TIMEOUT=$(bashio::config 'event_stale_timeout' 3600)

# Validate required configuration
if [ -z "$BRIDGE_IP" ]; then
    bashio::log.error "bridge_ip is required but not set"
    exit 1
fi

if [ -z "$PIN" ]; then
    bashio::log.error "pin is required but not set"
    exit 1
fi

# Ensure config directory and tado_local subdirectory exist
mkdir -p /config/tado_local

# Log configuration
bashio::log.info "Starting Tado Local..."
bashio::log.info "Bridge IP: ${BRIDGE_IP}"
bashio::log.info "Database: ${STATE_DB}"
bashio::log.info "HomeKit event stale timeout: ${EVENT_STALE_TIMEOUT}s"

# Start tado_local with unbuffered output for real-time logs
# PYTHONUNBUFFERED=1 ensures logs appear immediately in Home Assistant
python3 -u -m tado_local \
    --state "${STATE_DB}" \
    --bridge-ip "${BRIDGE_IP}" \
    --pin "${PIN}" \
    --event-stale-timeout "${EVENT_STALE_TIMEOUT}"
