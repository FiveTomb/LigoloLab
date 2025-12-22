# Multi-Hop Ligolo Docker Lab

This repository contains a Docker Compose lab for practicing
multi-hop pivoting with Ligolo-NG.

## Topology

Kali (host)
  |
  |-- dmz_net (bridge)
        |
        +-- pivot1
              |
              |-- internal1_net (macvlan)
                    |
                    +-- pivot2
                          |
                          |-- internal2_net (macvlan)
                                |
                                +-- target (nginx)

## Requirements

- Linux host
- Docker + Docker Compose
- `/dev/net/tun` available
- Ligolo-NG proxy on host

## Usage

```bash
docker compose up -d

