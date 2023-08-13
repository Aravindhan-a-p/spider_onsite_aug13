#! /usr/bin/bash
sudo apt install tor-browser launcher
sudo apt install -y tor

read -p "enter name of html page" name

echo "HiddenServiceDir /var/lib/tor/hidden_service/" | sudo tee -a /etc/tor/torrc
echo  "HiddenServicePort 80 127.0.0.1:80" | sudo tee -a /etc/tor/torrc
sudo systemctl restart tor
hostname=$(sudo cat /var/lib/tor/hidden_service/hostname)
echo $hostname
export $hostname ./nginx.conf
sudo apt install -y nginx

sudo ln -s /etc/nginx/sites-available/"$hostname.conf" /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx


