#!/bin/bash
set -ex
# Install_lamp.sh
## Instalamos Apache HTTP Server, MariaDB y PHP en un sistema Red Hat
### Actualizamos los repositorios
dnf update -y

### Instalamos Apache HTTP Server
dnf install -y httpd

### Iniciamos y habilitamos Apache
systemctl enable --now httpd

### Copiamos el archivo de configuración (ajustado para Red Hat)
cp ../Conf/000-default.conf /etc/httpd/conf.d/default.conf

### Instalamos MariaDB (MySQL compatible)
dnf install -y mariadb-server

### Iniciamos y habilitamos MariaDB
systemctl enable --now mariadb

### Instalamos PHP y extensión para MySQL
dnf install -y php php-mysqlnd

### Copiamos el archivo index.php de la práctica al directorio raíz de Apache
cp Practica02-iaw/php/index.php /var/www/html/index.php

### Reiniciamos Apache para aplicar cambios
systemctl restart httpd