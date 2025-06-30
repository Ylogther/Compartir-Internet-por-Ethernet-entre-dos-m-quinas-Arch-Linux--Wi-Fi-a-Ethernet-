#!/bin/sh
# ------------------------------------------------------------------
#  lan-client.sh
#  Configura IP estática, gateway y DNS para salir a Internet
# ------------------------------------------------------------------
set -e

# === Ajusta solo estas tres líneas =================================
IFACE_LAN="enp3s0"      # interfaz ethernet hacia Máquina A
CLIENT_IP="10.0.0.2"    # IP de este PC
GATEWAY="10.0.0.1"      # IP de Máquina A
# ===================================================================

echo "[*] Configurando IP $CLIENT_IP/24 en $IFACE_LAN..."
sudo ip addr add "$CLIENT_IP/24" dev "$IFACE_LAN" || true
sudo ip route add default vía "$GATEWAY"

echo "✔ Conexión lista. Prueba con:  ping -c3 archlinux.org"