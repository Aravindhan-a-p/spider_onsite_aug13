#! /usr/bin/bash
sudo apt update
sudo apt install -y tor

read -p "enter name of html page" name

echo "HiddenServiceDir /var/lib/tor/hidden_service/" | sudo tee -a /etc/tor/torrc
echo  "HiddenServicePort 80 127.0.0.1:80" | sudo tee -a /etc/tor/torrc
sudo systemctl restart tor
hostname=$(sudo cat /var/lib/tor/hidden_service/hostname)

sudo apt install -y nginx

sudo tee /etc/nginx/sites-available/"$hostname.conf" > /dev/null << EOF
server {
    listen 80;
    listen [::]:80;
    access_log var/log/nginx/access-$hostname;
    error_log var/log/nginx/error-$hostname;
    server_name $hostname;
    root /home/board/hidden_service/;
    index $name;
}
EOF
sudo ln -s /etc/nginx/sites-available/"$hostname" /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx


