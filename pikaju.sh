apt update && apt upgrade -y
apt install curl socat -y
curl https://get.acme.sh | sh
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --register-account -m enschu@gmail.com
~/.acme.sh/acme.sh --issue -d v157173.syntaxdump.com --standalone --force
~/.acme.sh/acme.sh --installcert -d v157173.syntaxdump.com --key-file /root/private.key --fullchain-file /root/cert.crt
bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
