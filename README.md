Here’s a polished **GitHub-style README** with badges, clean sections, and a professional lab vibe.

You can paste this directly into `README.md`.

---

# 🔐 Ligolo Multi-Hop Pivot Lab (Docker Edition)

![Docker](https://img.shields.io/badge/Docker-Required-blue)
![Compose](https://img.shields.io/badge/Docker%20Compose-v2+-blue)
![Mode](https://img.shields.io/badge/Modes-Sysadmin%20%7C%20CTF-purple)
![License](https://img.shields.io/badge/Lab-Private-lightgrey)

A reproducible, profile-driven multi-hop pivoting lab built entirely with Docker.

Designed for practicing:

* Multi-hop pivoting (Ligolo-ng, SOCKS, TUN-based tooling)
* Linux enumeration
* Credential discovery
* Privilege escalation
* Internal network segmentation
* Lateral movement simulation

This lab runs completely offline and is portable across systems.

---

# 🗺 Architecture

```
Kali VM
  │
  ├── dmz_net (172.31.50.0/24)
  │       └── pivot1
  │
  ├── internal1_net (10.200.1.0/24)
  │       └── pivot2
  │
  └── internal2_net (10.200.2.0/24)
          └── target (nginx)
```

### Key Design Goals

* Strict network segmentation
* Realistic Linux user structure
* Intentional misconfigurations
* Scenario-driven attack paths
* Clean profile switching

---

# 🧩 Lab Modes (Profiles)

This lab uses Docker Compose profiles to simulate different environments.

---

## 🔵 Sysadmin Misconfiguration Mode

Simulates an operational mistake commonly seen in internal environments.

### Scenario

* Cron job runs as `backup`
* World-readable environment file leaks credentials
* `backup` has limited sudo access (`tar` NOPASSWD)

### Attack Flow

```
websvc → discover leaked env → su backup → sudo tar → root
```

### Run It

```bash
docker compose --profile sysadmin up -d --build
```

---

## 🔴 CTF Mode

Puzzle-style scenario with intentional clues.

### Scenario

* Encoded credential clue in web directory
* Requires discovery and decoding
* Same privilege escalation path

### Run It

```bash
docker compose --profile ctf up -d --build
```

---

# 🚀 Quick Start

### 1️⃣ Build and Launch

```bash
docker compose --profile sysadmin up -d --build
```

### 2️⃣ Start from Low Privilege

```bash
docker exec -it -u websvc pivot1 bash
```

### 3️⃣ Begin Enumeration

```bash
ls /home
cat /usr/local/bin/.backup_env
```

---

# 👤 Default Users (Lab Only)

| User   | Purpose                                  |
| ------ | ---------------------------------------- |
| websvc | Initial foothold                         |
| backup | Operational account (misconfigured sudo) |
| admin  | Standard interactive user                |

**Passwords (for lab purposes only):**

```
backup → backup123
admin  → Winter2024!
```

---

# 📁 Project Structure

```
.
├── docker-compose.yml
├── Dockerfile.pivot
├── entrypoint.sh
├── profiles/
│   ├── sysadmin/
│   │   └── seed/
│   └── ctf/
│       └── seed/
```

### Components

* **Dockerfile.pivot**
  Base pivot image with users, tools, and sudo configuration.

* **entrypoint.sh**
  Applies profile-specific seed artifacts at runtime.

* **profiles/**
  Scenario-specific files injected into pivots.

---

# 🔧 Requirements

* Docker
* Docker Compose (v2+)
* Kali VM (recommended)
* Network interface supporting macvlan

Check your interface:

```bash
ip -br addr
```

Update `parent:` in `docker-compose.yml` if not `eth0`.

---

# 🔄 Switching Modes Cleanly

When switching profiles, remove the seed volume:

```bash
docker compose --profile sysadmin down -v
docker volume rm ligololab_seed 2>/dev/null || true
```

Then start the other mode:

```bash
docker compose --profile ctf up -d --build
```

---

# 🧪 Suggested Practice Objectives

* Enumerate Linux users correctly (don’t rely only on `/home`)
* Identify operational accounts
* Locate leaked credentials
* Pivot users safely
* Escalate via limited sudo
* Access internal-only services via multi-hop tunneling

---

# 🧹 Cleanup

Stop and remove everything:

```bash
docker compose down -v
docker network prune -f
docker volume prune -f
```

---

# ⚠️ Security Notice

This lab is intended for:

* Offline environments
* Private research
* Controlled experimentation

Do **not** expose these containers to public networks.

---

# 📌 Future Enhancements

* Internal-only database service
* SSH lateral movement simulation
* Credential reuse between pivots
* Logging & detection simulation
* Blue-team monitoring variant
