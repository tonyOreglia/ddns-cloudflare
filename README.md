# Cloudflare DDNS Updater

A lightweight Bash script that keeps a Cloudflare DNS A record updated with your current public IP address.  
Useful for self-hosting behind a dynamic home IP.

---

## Features

- Detects public IP changes  
- Updates Cloudflare DNS automatically  
- Loads configuration from `.env`  
- Safe for cron execution  
- Logs progress and errors  
- Stores last known IP locally  

---

## Requirements

- Cloudflare-managed DNS domain  
- Cloudflare API Token with permissions:
  - **Zone → Zone → Read**  
  - **Zone → DNS → Edit**

---

## Installation

Place the following files into a dedicated directory:

```
cloudflare-ddns.sh
.env
```

### 1. Create `.env` file and update the values

```bash
cp .env.example .env
```

### 2. Make the script executable

```bash
chmod +x cloudflare-ddns.sh
```

### 3. Test manually

```bash
./cloudflare-ddns.sh
```

You should see progress logs and a `ip-log.txt` file created.

---

## Cron Setup

Run the script automatically every 5 minutes:

```bash
crontab -e
```

Add:

```
*/5 * * * * /path/to/cloudflare-ddns.sh >> /path/to/cloudflare-ddns.log 2>&1
```

This:

- Executes the script every 5 minutes  
- Logs output to `cloudflare-ddns.log`  
- Ensures your DNS updates quickly when your IP changes  

---

## Files Created

| File | Purpose |
|------|---------|
| `ip-log.txt` | Stores last known public IP |
| `cloudflare-ddns.log` | Optional cron logging output |

---

## Uninstall

1. Remove the cron entry:

```bash
crontab -e
```

2. Delete the script directory.

