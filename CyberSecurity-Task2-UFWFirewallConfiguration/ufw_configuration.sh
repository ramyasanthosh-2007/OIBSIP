#!/bin/bash

echo "Applying UFW Firewall Configuration..."

sudo ufw --force enable

sudo ufw allow ssh

sudo ufw deny http

sudo ufw allow https

sudo ufw deny 23/tcp

echo
echo "Current Firewall Status:"
sudo ufw status verbose

echo
echo "Firewall configuration completed successfully."
