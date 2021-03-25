#!/bin/bash
set -e

curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh

export AUTO_INSTALL=y
export APPROVE_IP=y
export IPV6_SUPPORT=n
export ENDPOINT={{ vars.vmPublicFQDN }}

sudo -E ./openvpn-install.sh
sudo cp /root/client.ovpn /home/{{ vars.adminUsername }}/client.ovpn 
sudo cp /root/client.ovpn /etc/openvpn/client.ovpn 
sudo chown {{ vars.adminUsername }} /home/{{ vars.adminUsername }}/client.ovpn
