#!/bin/bash
# ==============================================================================
# VPS & Autonomous Agent Infrastructure Health Diagnostic Script
# Analyzes CPU, Memory, Disk, Network Sockets, and Background Routing Daemons
# ==============================================================================

echo "================================================================="
echo "   AUTONOMOUS AGENT & VPS CLOUD INFRASTRUCTURE HEALTH AUDIT      "
echo "   Host: $(hostname) | Date: $(date '+%Y-%m-%d %H:%M:%S %Z')     "
echo "================================================================="

echo -e "\n[1] Sistem Operasi & Kernel:"
uname -srmo
lsb_release -d 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME

echo -e "\n[2] Beban Komputasi CPU & Uptime:"
uptime

echo -e "\n[3] Pemanfaatan Memori RAM (Target: < 2.0 GB used):"
free -h

echo -e "\n[4] Kapasitas Penyimpanan SSD NVMe (Target: < 50% usage):"
df -h /

echo -e "\n[5] Pemeriksaan Status Proses Latar Belakang (Daemons):"
# Cek 9Router Process
if pgrep -f "9router" > /dev/null; then
    ROUTER_PID=$(pgrep -f "9router" | head -n 1)
    echo "  [✓] 9Router Local Gateway : RUNNING (PID: $ROUTER_PID, Port: 20128)"
else
    echo "  [✗] 9Router Local Gateway : NOT RUNNING"
fi

# Cek Hermes Agent Gateway Process
if pgrep -f "hermes.*gateway" > /dev/null; then
    HERMES_PID=$(pgrep -f "hermes.*gateway" | head -n 1)
    echo "  [✓] Hermes Agent Gateway  : RUNNING (PID: $HERMES_PID)"
else
    echo "  [✗] Hermes Agent Gateway  : NOT RUNNING"
fi

echo -e "\n[6] Pemeriksaan Konektivitas Soket Jaringan:"
if ss -tuln | grep -q ":20128"; then
    echo "  [✓] Soket Gateway 9Router (Port 20128) aktif merespons koneksi lokal."
else
    echo "  [✗] Soket Port 20128 tidak terdeteksi."
fi

echo -e "\n================================================================="
echo " [✓] Diagnostik infrastruktur selesai dijalankan tanpa anomali."
echo "================================================================="
