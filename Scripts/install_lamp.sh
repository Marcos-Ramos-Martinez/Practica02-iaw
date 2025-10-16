#!/bin/bash
set -ex

# Actalizamos los repositorios
dnf update -y

# Instalamos el servidor web apacheHTTP server
dnf install httpd -y

#Iniciamos y ahabilitamos el servicio de Apache
systemctl start httpd
systemctl enable httpd

# Instalamos MYSQL server
dnf install mariadb-server -y

#Iniciamos y ahabilitamos el servicio de MYSQL
systemctl start mariadb.service
systemctl enable mariadb.service