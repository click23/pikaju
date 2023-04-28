#!/bin/bash

# Ask the user for the domain and email
read -p "Enter the domain to be installed on: " DOMAIN
read -p "Enter an email to be used for the ACME shell script: " EMAIL

# Update the system and install required packages
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install curl socat -y

# Install and configure ACME.sh to obtain an SSL certificate
curl https://get.acme.sh | sh
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --register-account -m "$EMAIL"
~/.acme.sh/acme.sh --issue -d "$DOMAIN" --standalone --force
~/.acme.sh/acme.sh --installcert -d "$DOMAIN" --key-file /root/private.key --fullchain-file /root/cert.crt

# Install X-UI panel
bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
