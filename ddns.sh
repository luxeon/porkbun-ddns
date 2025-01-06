#!/bin/bash

source /path/to/porkbun_keys.sh

# Parameters
#PORKBUN_API_KEY=your-porkbun-api-key
#PORKBUN_API_SECRET=your-porkbun-api-secret
DOMAIN="example.com"
SUBDOMAIN="ddns"
TTL=300
IP_FILE="/tmp/current_ip.txt"  # File to store the last known IP

# Get the current IP
CURRENT_IP=$(curl -s https://api.ipify.org)

# Create the IP file if it does not exist
if [ ! -f "$IP_FILE" ]; then
  echo "$CURRENT_IP" > "$IP_FILE"
  echo "IP file created: $CURRENT_IP"
fi

# Read the last known IP
LAST_IP=$(cat "$IP_FILE")

# Check if the IP has changed
if [ "$CURRENT_IP" != "$LAST_IP" ]; then
  # URL for updating the DNS record
  API_URL="https://porkbun.com/api/json/v3/dns/editByNameType/$DOMAIN/A/$SUBDOMAIN"

  # Data for the update request
  DATA=$(cat <<EOF
{
  "apikey": "$PORKBUN_API_KEY",
  "secretapikey": "$PORKBUN_API_SECRET",
  "content": "$CURRENT_IP",
  "ttl": $TTL
}
EOF
  )

  # Execute the update request
  RESPONSE=$(curl -s -X POST "$API_URL" -H "Content-Type: application/json" -d "$DATA")

  # Check the response
  if [[ "$RESPONSE" == *'"status":"SUCCESS"'* ]]; then
    echo "DDNS updated: $SUBDOMAIN.$DOMAIN -> $CURRENT_IP"
    echo "$CURRENT_IP" > "$IP_FILE"  # Update the stored IP
  else
    echo "Error updating DDNS: $RESPONSE"
  fi
else
  echo "IP has not changed: $CURRENT_IP"
fi