#!/bin/bash
echo "=== System Report ==="
echo "Date: $(date)"
echo "User: $(whoami)"
echo "OS: $(uname -s -r)"
echo "CPU Cores: $(nproc)"
echo "Memory: $(free -h | awk '/Mem/{print $3 "/" $2}') used"
echo "Disk Usage" 
echo "_________________________"
df -h | grep -v loop
echo "=== Report End ==="
