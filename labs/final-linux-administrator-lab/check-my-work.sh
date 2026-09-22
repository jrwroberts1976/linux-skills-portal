#!/bin/bash

#
# Final Linux Administrator Lab - Assessment Script
#

PASS=0
FAIL=0

pass_check() {
    echo "[PASS] $1"
    PASS=$((PASS+1))
}

fail_check() {
    echo "[FAIL] $1"
    FAIL=$((FAIL+1))
}

echo "====================================="
echo " Linux Administrator Final Assessment"
echo "====================================="
echo ""

#
# System Checks
#

echo "Checking system information..."

if [ -f /etc/os-release ]; then
    pass_check "Operating system information available"
else
    fail_check "Missing operating system information"
fi


if hostname >/dev/null 2>&1; then
    pass_check "Hostname configured"
else
    fail_check "Hostname unavailable"
fi


#
# User Checks
#

echo ""
echo "Checking user configuration..."

if id adminuser >/dev/null 2>&1; then
    pass_check "Admin user exists"
else
    fail_check "Admin user not created"
fi


if groups adminuser | grep -q sudo; then
    pass_check "Admin user has sudo access"
else
    fail_check "Admin user missing sudo access"
fi


#
# Storage Checks
#

echo ""
echo "Checking storage..."

if df -h / >/dev/null 2>&1; then
    pass_check "Filesystem information available"
else
    fail_check "Filesystem check failed"
fi


if [ -d /opt/application ]; then
    pass_check "/opt/application directory exists"
else
    fail_check "/opt/application directory missing"
fi


#
# Networking Checks
#

echo ""
echo "Checking networking..."

if ip address >/dev/null 2>&1; then
    pass_check "Network interfaces available"
else
    fail_check "Network interfaces unavailable"
fi


if ip route | grep -q default; then
    pass_check "Default gateway configured"
else
    fail_check "No default gateway found"
fi


#
# Package Checks
#

echo ""
echo "Checking administration tools..."

for cmd in htop curl wget tree; do

    if command -v $cmd >/dev/null 2>&1; then
        pass_check "$cmd installed"
    else
        fail_check "$cmd missing"
    fi

done


#
# Service Checks
#

echo ""
echo "Checking services..."

if systemctl is-active --quiet nginx; then
    pass_check "Nginx service running"
else
    fail_check "Nginx service not running"
fi


if systemctl is-enabled --quiet nginx; then
    pass_check "Nginx enabled at boot"
else
    fail_check "Nginx not enabled at boot"
fi


#
# Security Checks
#

echo ""
echo "Checking security..."

if command -v ufw >/dev/null 2>&1; then

    if ufw status | grep -q active; then
        pass_check "Firewall enabled"
    else
        fail_check "Firewall not enabled"
    fi

else
    fail_check "UFW not installed"
fi


#
# Port Checks
#

echo ""
echo "Checking listening services..."

if ss -tulnp | grep -q :80; then
    pass_check "HTTP port 80 listening"
else
    fail_check "HTTP port 80 not listening"
fi


#
# Script Check
#

echo ""
echo "Checking monitoring script..."

if [ -f system-check.sh ]; then

    if [ -x system-check.sh ]; then
        pass_check "system-check.sh exists and executable"
    else
        fail_check "system-check.sh not executable"
    fi

else
    fail_check "system-check.sh missing"
fi


#
# Results
#

echo ""
echo "====================================="
echo " Assessment Complete"
echo "====================================="

echo ""
echo "Passed: $PASS"
echo "Failed: $FAIL"

echo ""

if [ $FAIL -eq 0 ]; then

    echo "RESULT: SUCCESS"
    echo "Congratulations - Linux Administrator Lab completed."

    exit 0

else

    echo "RESULT: REVIEW REQUIRED"
    echo "Check failed items and correct your configuration."

    exit 1

fi
