# 📡 Compartir Internet por Ethernet entre dos máquinas Arch Linux (Wi-Fi → RJ45)

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Arch Linux](https://img.shields.io/badge/compatibilidad-ArchLinux-%236C6C6C?logo=arch-linux&logoColor=white)
![Estado: Estable](https://img.shields.io/badge/estado-estable-brightgreen)
![Shell Script](https://img.shields.io/badge/bash-compatible-yellowgreen)
![Soporte: NAT + IP estática](https://img.shields.io/badge/soporte-NAT%20%2B%20IP%20est%C3%A1tica-orange)

---

## ✨ Descripción

Este proyecto permite compartir tu conexión a Internet **desde una máquina con Wi-Fi** hacia otra conectada por **cable Ethernet (RJ45)**, usando herramientas nativas de Linux como `iproute2`, `iptables` y `systemd`.

Es una solución **minimalista**, ideal para **sistemas Arch Linux o derivados** que no usan `NetworkManager`, con control total sobre el enrutamiento y sin dependencias innecesarias.

---

## 🧰 Contenido

- `share-internet.sh` – Script para la **máquina que comparte** internet (Wi-Fi a Ethernet).
- `lan-client.sh` – Script para la **máquina que recibe** internet por Ethernet.
- Servicios systemd opcionales (`*.service`) para ejecución automática al inicio del sistema.

---

## 📦 Requisitos

- Dos máquinas con Linux (idealmente Arch)
- Interfaces disponibles:  
  - Wi-Fi (ej: `wlan0`)  
  - Ethernet (ej: `enp3s0`)
- Paquetes necesarios:
  ```bash
  sudo pacman -S --needed iproute2 iptables-nft
````

---

## ⚙️ Instalación rápida

### 🔹 Máquina A (la que comparte Internet)

```bash
sudo install -m755 share-internet.sh /usr/local/sbin/
sudo cp share-internet.service /etc/systemd/system/
sudo systemctl enable --now share-internet.service
```

> ⚠️ Edita `share-internet.sh` para configurar correctamente tus interfaces (`IFACE_WAN`, `IFACE_LAN`).

---

### 🔹 Máquina B (cliente)

```bash
sudo install -m755 lan-client.sh /usr/local/sbin/
sudo cp lan-client.service /etc/systemd/system/
sudo systemctl enable --now lan-client.service
```

> ⚠️ Ajusta la IP local (`CLIENT_IP`) y el gateway (`GATEWAY`) en `lan-client.sh`.

---

## 🖥️ Esquema de red

```plaintext
┌─────────────┐      Wi-Fi      ┌──────────────┐      Ethernet       ┌─────────────┐
│   Internet  │◄──────────────►│  Máquina A    │◄───────────────────►│  Máquina B  │
└─────────────┘                │(Compartidor)  │                    │ (Cliente)   │
                              └──────────────┘                    └─────────────┘
```

---

## ✅ Estado del proyecto

Este script es **estable**, probado en múltiples escenarios:

* Conexión NAT funcional
* Transferencias directas con `iperf3`, `rsync` y `scp`
* Acceso completo a DNS, HTTP, HTTPS
* Sin interferencias con redes existentes

---

## 🔐 Seguridad

* Reglas `iptables` mínimas, solo NAT + forwarding.
* No se expone ningún puerto externo ni se levanta ningún demonio innecesario.
* Puedes auditar y reforzar fácilmente la configuración.

---

## 📝 Licencia

Este proyecto está licenciado bajo la **[MIT License](LICENSE)**.
Puedes usarlo, modificarlo y distribuirlo libremente bajo los términos de dicha licencia.

---
