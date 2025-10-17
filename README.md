# Practica02-iaw
Repositorio para la practica 02 de IAW del curso 25/26

# Install_lamp.sh
## Instalamos Apache(httpd)
### Actalizamos los repositorios
dnf update -y

### Instalamos el servidor web apacheHTTP server
dnf install httpd -y

### Iniciamos y ahabilitamos el servicio de Apache
systemctl start httpd
systemctl enable httpd

### Instalamos MYSQL server
dnf install mariadb-server -y

### Iniciamos y ahabilitamos el servicio de MYSQL
systemctl start mariadb.service
systemctl enable mariadb.service

### Instalamos PHP
dnf install php -y

### Instalamos la extensión de PHP para conectar con MySQL.
dnf install php-mysqlnd -y

### Reiniciar el servicio de Apache para que se apliquen los cambios.
systemctl restart httpd



