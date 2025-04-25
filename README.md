
markdown
# Compartir Internet por Ethernet entre dos máquinas Arch Linux (Wi-Fi a Ethernet)

Este repositorio contiene un script para permitir que una máquina Arch Linux actúe como **cliente**, conectándose a otra máquina Arch que está compartiendo su conexión Wi-Fi a través de un cable Ethernet.

## Escenario

- **Servidor (host)**: Conectado a una red Wi-Fi y comparte su conexión a internet mediante su interfaz Ethernet.
- **Cliente**: Se conecta al servidor mediante cable Ethernet para acceder a internet.

Este enfoque es útil cuando una máquina no tiene Wi-Fi, o se desea compartir internet directamente por cable.

---

## Requisitos

- Ambas máquinas usan **NetworkManager**.
- El servidor ha configurado la conexión cableada como `ipv4.method shared`.
- Ya hay un cable Ethernet conectado entre ambas máquinas.
- El cliente tiene una interfaz ethernet (como `enp4s0`) visible con `ip link`.

---

## Cliente: Script de conexión

Este script configura manualmente la IP, puerta de enlace y DNS en el **cliente**.

### Script `cliente.sh`

```bash
#!/bin/bash

# Interfaz Ethernet del cliente (ajústala si es diferente)
IFACE="enp4s0"

echo "[+] Activando interfaz $IFACE"
sudo ip link set $IFACE up

echo "[+] Limpiando IPs anteriores"
sudo ip addr flush dev $IFACE

echo "[+] Asignando IP estática"
sudo ip addr add 10.42.0.2/24 dev $IFACE

echo "[+] Agregando puerta de enlace"
sudo ip route add default via 10.42.0.1

echo "[+] Configurando DNS (Google)"
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

echo "[✓] Conexión lista. Puedes probar con: ping 8.8.8.8"
```

### Uso

1. Guarda el script como `cliente.sh`.
2. Da permisos de ejecución:

   ```bash
   chmod +x cliente.sh
   ```

3. Ejecuta el script:

   ```bash
   ./cliente.sh
   ```

---

## Servidor: Compartir internet por cable

1. Comparte la conexión Wi-Fi por Ethernet:

   ```bash
   nmcli connection modify "Conexión cableada 1" ipv4.method shared
   nmcli connection up "Conexión cableada 1"
   ```

2. Verifica que la IP compartida esté activa (por lo general `10.42.0.1`):

   ```bash
   ip a | grep enpXsY
   ```

---

## Verifica la conexión

En el cliente, ejecuta:

```bash
ping 8.8.8.8
```

Y si tienes respuesta, puedes intentar:

```bash
ping google.com
```

---

---

### `cliente.sh` (contenido para crear el script):

```bash
#!/bin/bash

# Interfaz Ethernet del cliente (ajústala si es diferente)
IFACE="enp4s0"

echo "[+] Activando interfaz $IFACE"
sudo ip link set $IFACE up

echo "[+] Limpiando IPs anteriores"
sudo ip addr flush dev $IFACE

echo "[+] Asignando IP estática"
sudo ip addr add 10.42.0.2/24 dev $IFACE

echo "[+] Agregando puerta de enlace"
sudo ip route add default via 10.42.0.1

echo "[+] Configurando DNS (Google)"
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf

echo "[✓] Conexión lista. Puedes probar con: ping 8.8.8.8"
```
