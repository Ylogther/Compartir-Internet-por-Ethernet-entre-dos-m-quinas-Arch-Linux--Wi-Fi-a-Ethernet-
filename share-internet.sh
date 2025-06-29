#!/usr/bin/env bash
# ------------------------------------------------------------------
#  share-internet.sh
#  Comparte la conexión de IFACE_WAN hacia IFACE_LAN por NAT
# ------------------------------------------------------------------
set -euo pipefail

# === Ajusta solo estas cuatro líneas ==============================
IFACE_WAN="wlan0"      # interfaz que YA tiene acceso a Internet
IFACE_LAN="enp5s0"     # interfaz ethernet al otro PC
LAN_IP="10.0.0.1"      # IP que tendrá esta máquina en la LAN
LAN_NETMASK="24"       # /24 == 255.255.255.0
# ==================================================================

echo "[*] Configurando IP $LAN_IP/$LAN_NETMASK en $IFACE_LAN..."
ip addr add "$LAN_IP/$LAN_NETMASK" dev "$IFACE_LAN" || true
ip link set "$IFACE_LAN" up

echo "[*] Habilitando IP forwarding..."
sysctl -w net.ipv4.ip_forward=1 > /dev/null
mkdir -p /etc/sysctl.d
echo "net.ipv4.ip_forward = 1" >/etc/sysctl.d/40-ipforward.conf

echo "[*] Aplicando reglas NAT (iptables‑nft)..."
iptables -t nat -C POSTROUTING -o "$IFACE_WAN" -j MASQUERADE 2>/dev/null \
  || iptables -t nat -A POSTROUTING -o "$IFACE_WAN" -j MASQUERADE

iptables -C FORWARD -i "$IFACE_LAN" -o "$IFACE_WAN" -j ACCEPT 2>/dev/null \
  || iptables -A FORWARD -i "$IFACE_LAN" -o "$IFACE_WAN" -j ACCEPT

iptables -C FORWARD -i "$IFACE_WAN" -o "$IFACE_LAN" -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null \
  || iptables -A FORWARD -i "$IFACE_WAN" -o "$IFACE_LAN" -m state --state RELATED,ESTABLISHED -j ACCEPT

echo "[*] Guardando reglas para que persistan..."
iptables-save >/etc/iptables/iptables.rules

echo "✔ Listo. El PC conectado a $IFACE_LAN ya puede usar Internet vía $IFACE_WAN."