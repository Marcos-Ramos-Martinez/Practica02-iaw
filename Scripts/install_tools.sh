#!/bin/bash
set -ex

# Importamos el archivo .env
source .env

# Instalamos PHPmyAdmin
dnf update
dnf install php-mbstring php-zip php-json php-gd php-fpm php-xml -y

# Reiniciamos el servicio de Apache para que se apliquen los cambios.
systemctl restart httpd

# Accedemos al directorio /var/www/html.
cd /var/www/html

# Instalamos la utilidad wget para poder descargar el código fuente de phpMyAdmin.
dnf install wget -y

# Descargamos el código fuente de phpMyAdmin.
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz

# Descomprimimos el archivo que acabamos de descargar.
tar xvf phpMyAdmin-latest-all-languages.tar.gz

# Eliminamos el archivo .tar.gz.
rm phpMyAdmin-latest-all-languages.tar.gz

# Renombramos el directorio.
mv /var/www/html/phpMyAdmin-*-all-languages/ phpmyadmin

#--------------------------------------------------------------------------------------------------------------------------------------------------
# Creamos usuario y contraseña para la base de datos
mysql -u root -e "drop user if exists $DB_USER@'%'"
mysql -u root -e "Create user $DB_USER@'%' IDENTIFIED BY '$DB_PASSWORD'"

# Le damos privilegios al usuario
mysql -u root -e "Grant all privileges on $DB_NAME.* TO $DB_USER@'%'"
mysql -u root -e "FLUSH PRIVILEGES"