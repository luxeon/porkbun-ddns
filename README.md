# Dynamic DNS Updater for Porkbun with Bash

This repository contains a lightweight Bash script that enables dynamic DNS (DDNS) updates for domains managed through Porkbun. The script automatically updates your DNS records when your external IP address changes, making it ideal for use with home networks or any dynamic IP setup.

## Features

- **Automated IP Address Detection**: Uses `ipify.org` to fetch the current public IP.
- **Change Detection**: Updates DNS records only when the IP address has changed, reducing unnecessary API calls.
- **Configurable Parameters**: Easily customize domain, subdomain, and TTL.
- **Simple and Lightweight**: No dependencies beyond `curl` and standard Unix utilities.
- **Secure Key Management**: Supports external storage of API keys to avoid embedding sensitive data in the script.

## Requirements

- A registered domain with [Porkbun](https://porkbun.com).
- Porkbun API key and secret.
- A Unix-like environment with `bash` and `curl` installed.

## Setup

### Step 1: Obtain API Credentials
1. Log in to your Porkbun account.
2. Navigate to the **Account** - **Domain Management** - **Details** - Enable **API ACCESS**
3. Navigate to the **Account** - **API Access** and generate an API key and secret.

### Step 2: Create an API Key File
For improved security, store your API keys in a separate file (e.g., `porkbun_keys.sh`) and load them into your script.

Create the file:
```bash
#!/bin/bash

# /path/to/porkbun_keys.sh
export PORKBUN_API_KEY="your-porkbun-api-key"
export PORKBUN_API_SECRET="your-porkbun-api-secret"
```
Set appropriate permissions:
```bash
chmod 600 /path/to/porkbun_keys.sh
```

### Step 3: Modify the Script
Customize the following parameters in the script:

- `DOMAIN="example.com"`: Replace with your domain name.
- `SUBDOMAIN="ddns"`: Replace with your subdomain.
- `TTL=300`: Set the desired TTL for your DNS record.

Update the `source` command to load the API keys:
```bash
source /path/to/porkbun_keys.sh
```

### Step 4: Automate with Cron
To automate IP checks and updates, add a cron job:
```bash
crontab -e
```
and add:
```bash
*/5 * * * * /path/to/ddns_update.sh >> /var/log/ddns_update.log 2>&1
```
This example runs the script every 5 minutes and logs output to `/var/log/ddns_update.log`.

## Important Notes

1. **Security**: Never commit your API keys to a public repository. Use the `porkbun_keys.sh` method to keep them separate.
2. **Logging**: Direct output to a log file for debugging and monitoring.
3. **IP Fetching**: This script uses `ipify.org`, a free service. Consider using alternatives if needed.

## Troubleshooting

- **No IP Change Detected**: Ensure the script runs correctly by checking the IP stored in `/tmp/current_ip.txt`.
- **Permission Denied**: Ensure the script and key file have appropriate permissions (`chmod +x` for the script).
- **Error Responses**: Check the full API response for hints if updates fail.

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contributions
Pull requests are welcome. Please ensure compatibility with standard Unix environments.

## Acknowledgements
- [Porkbun API](https://porkbun.com/api/json/v3/documentation) for their API.
- [ipify](https://api.ipify.org) for IP address detection.

