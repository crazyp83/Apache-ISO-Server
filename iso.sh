#!/bin/bash

# Update package list and install apache2
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y apache2

# Enable required Apache modules
sudo a2enmod proxy proxy_http

# Create a directory to store ISO files and set permissions
ISO_DIR="/var/www/html/iso"
sudo mkdir -p ${ISO_DIR}
sudo chown -R www-data:www-data ${ISO_DIR}
sudo chmod -R 755 ${ISO_DIR}

# Create a virtual host configuration for serving ISO files
VHOST_CONF="/etc/apache2/sites-available/iso.conf"
cat > ${VHOST_CONF} << EOL
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot ${ISO_DIR}

    ErrorLog \${APACHE_LOG_DIR}/iso-error.log
    CustomLog \${APACHE_LOG_DIR}/iso-access.log combined

    ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:80/
    ProxyPassReverse / http://127.0.0.1:80/
</VirtualHost>
EOL

# Enable the ISO virtual host
sudo a2ensite iso

# Restart Apache
sudo /etc/init.d/apache2 reload

#Define the base URL
BASE_URL="https://releases.rancher.com/harvester/v1.2.1/harvester-v1.2.1"

#Download the ISO files
for file in amd64.iso initrd-amd64 vmlinuz-amd64 rootfs-amd64.squashfs
do
  wget -P ${ISO_DIR} ${BASE_URL}-${file} || \
  { echo "BRO! Failed to download ${file}! Exiting script. Fix that script!"; exit 1; }
done

echo "Wow! the ISO files downloaded to ${ISO_DIR}"
