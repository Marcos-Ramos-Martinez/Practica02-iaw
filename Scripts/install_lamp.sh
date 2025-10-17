#!/bin/bash
set -ex

# Actalizamos los repositorios
dnf update -y

# Instalamos el servidor web apacheHTTP server
dnf install httpd -y

#Iniciamos y ahabilitamos el servicio de Apache
systemctl start httpd
systemctl enable httpd

# Copiamos el archivo de configuracion de Apache
cp ../Conf/000-default.conf /etc/httpd/conf.d

# Instalamos MYSQL server
dnf install mariadb-server -y

# Iniciamos y ahabilitamos el servicio de MYSQL
systemctl start mariadb.service
systemctl enable mariadb.service

# Instalamos PHP
dnf install php -y

# Instalamos la extensión de PHP para conectar con MySQL.
dnf install php-mysqlnd -y

# Reiniciar el servicio de Apache para que se apliquen los cambios.
systemctl restart httpd

