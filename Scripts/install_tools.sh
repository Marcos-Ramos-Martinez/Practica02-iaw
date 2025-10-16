#!/bin/bash
set -ex

# Importamos el archivo .env
source .env

# Configuramos las respuestas de installacion de PHPyAdmin
# Se sacan de aqui: https://josejuansanchez.org/iaw/practica-01-01-teoria/index.html#otras-herramientas-relacionadas-con-la-pila-lamp
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $PHPMYADMIN_APP_PASSWORD" | debconf-set-selections

# Instalamos PHPmyAdmin
apt update
apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y

#--------------------------------------------------------------------------------------------------------------------------------------------------

# Instalacion de Adminer
mkdir -p /var/www/html/adminer

wget https://github.com/vrana/adminer/releases/download/v5.4.1/adminer-5.4.1-mysql.php -P /var/www/html/adminer

# Renobramos Adminer
mv /var/www/html/adminer/adminer-5.4.1-mysql.php /var/www/html/adminer/index.php

#--------------------------------------------------------------------------------------------------------------------------------------------------

# Creamos una base de datos de ejemplo
mysql -u root -e "Drop Database if exists $DB_NAME;" 
mysql -u root -e "create database $DB_NAME;" 

# Creamos usuario y contraseña para la base de datos
mysql -u root -e "drop user if exists $DB_USER@'%'"
mysql -u root -e "Create user $DB_USER@'%' IDENTIFIED BY '$DB_PASSWORD'"

# Le damos privilegios al usuario
mysql -u root -e "Grant all privileges on $DB_NAME.* TO $DB_USER@'%'"

#--------------------------------------------------------------------------------------------------------------------------------------------------

# Instalación de GoAccess
apt update
apt install goaccess -y

# Creamos el directorio stats.
mkdir -p /var/www/html/stats

# Creación de un archivo HTML en tiempo real en segundo plano
goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html --daemonize

# Reemplazar el archivo 000-default.conf
cp ../Conf/000-default-stats.conf /etc/apache2/sites-available/000-default.conf

# Copieamos el archivo .htaccess
cp ../htaccess/.htaccess /var/www/html/stats

# Indicamos el nombre y contraseña
htpasswd -bc /etc/apache2/.htpasswd $STATS_USERNAME $STATS_PASSWORD

# Reiniciamos apache2
systemctl restart apache2