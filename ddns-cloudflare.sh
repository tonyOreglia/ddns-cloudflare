#!/bin/bash

###########################################
# Cloudflare DDNS Update Script
###########################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load .env file
set -a            # automatically export all variables
source "$SCRIPT_DIR/.env"
set +a

IP_FILE="$SCRIPT_DIR/ip-log.txt"

# REQUIRED SETTINGS
ZONE_ID=$CLOUDFLARE_ZONE_ID
RECORD_ID=$CLOUDFLARE_RECORD_ID
API_TOKEN=$CLOUDFLARE_API_TOKEN
DNS_NAME=$DNS_NAME

# Get current public IP
CURRENT_IP=$(curl -s https://api.ipify.org)

if [ -z "$CURRENT_IP" ]; then
  echo "Failed to fetch public IP."
  exit 1
fi

# Read last IP if exists
if [ -f "$IP_FILE" ]; then
  LAST_IP=$(cat "$IP_FILE")
else
  LAST_IP=""
fi

# Compare
if [ "$CURRENT_IP" == "$LAST_IP" ]; then
  echo "IP unchanged ($CURRENT_IP). No update needed."
  exit 0
fi

# Update Cloudflare
echo "IP changed to $CURRENT_IP. Updating Cloudflare…"

UPDATE=$(curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'"$DNS_NAME"'","content":"'"$CURRENT_IP"'","comment":"updated by ddns cronjob"}')

# Check success
if echo "$UPDATE" | grep -q '"success":true'; then
  echo "$CURRENT_IP" > "$IP_FILE"
  echo "Cloudflare updated successfully."
else
  echo "Cloudflare update failed:"
  echo "$UPDATE"
  exit 1
fi

