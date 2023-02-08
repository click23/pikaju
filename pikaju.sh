#!/bin/bash
# Ask the user for their name
echo Hello, Please enter the domain to be installed on!
read domain
echo Now enter an email to be used for acme shell script!
read email

sudo apt update -y
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt clean -y

apt install curl socat -y

curl https://get.acme.sh | sh
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --register-account -m $email
~/.acme.sh/acme.sh --issue -d $domain --standalone --force
~/.acme.sh/acme.sh --installcert -d $domain --key-file /root/private.key --fullchain-file /root/cert.crt

bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
