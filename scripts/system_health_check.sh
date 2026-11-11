#!/bin/bash
# Autonomous Agent & VPS Environment Health Check Script
echo "================================================="
echo " VPS AUTONOMOUS AGENT SYSTEM DIAGNOSTICS"
echo " Date: $(date '+%Y-%m-%d %H:%M:%S %Z')"
echo "================================================="

echo -e "\n[1] CPU & Host Load:"
uptime

echo -e "\n[2] Memory Utilization:"
free -h

echo -e "\n[3] Storage Utilization:"
df -h /

echo -e "\n[4] Active Background Services:"
systemctl is-active cron.service dbus.service

echo -e "\n[✓] Diagnostic completed successfully."
