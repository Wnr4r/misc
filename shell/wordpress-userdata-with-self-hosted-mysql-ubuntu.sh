#!/bin/bash
# AUTOMATIC WORDPRESS INSTALLER IN  AWS Ubuntu Server 20.04 LTS (HVM)
# CHANGE DATABASE VALUES BELOW AND PASTE IT TO USERDATA SECTION In ADVANCED SECTION WHILE LAUNCHING EC2

#Change these values and keep in safe place
db_root_password=rootpass
db_username=whoami
db_user_password=passpass
db_name=wp_coded

# install LAMP Server
apt update  -y
apt upgrade -y
#install apache server
apt install -y apache2
 


apt install -y php
apt install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,bcmath,json,xml,intl,zip,imap,imagick}



#and download mysql package to yum  and install mysql server from yum
apt install -y mysql-server mysql-common


# starting apache and mysql server and register them to startup

systemctl enable --now  apache2
systemctl enable --now mysql

# Change OWNER and permission of directory /var/www
usermod -a -G www-data ubuntu
chown -R ubuntu:www-data /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;


# Download wordpress package and extract
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/


# AUTOMATIC mysql_secure_installation
#stopping mysql and starting with safe mode
systemctl stop mysql
mkdir /var/run/mysqld
chown mysql:mysql /var/run/mysqld
mysqld_safe --skip-grant-tables >res 2>&1 &


#change root password to db_root_password

mysql -uroot -e "UPDATE mysql.user SET authentication_string=null WHERE User='root';"
mysql -uroot -e " UPDATE mysql.user SET plugin='mysql_native_password'  WHERE User='root';flush privileges"

killall -v mysqld

systemctl stop mysql 
systemctl start mysql


mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$db_root_password';FLUSH PRIVILEGES;" 
mysql -uroot -p$db_root_password  -e "DELETE FROM mysql.user WHERE User='';"
mysql -uroot -p$db_root_password -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"


# Create database user and grant privileges
mysql -uroot -p$db_root_password -e "CREATE USER '$db_username'@'localhost' IDENTIFIED BY '$db_user_password';"
mysql -uroot -p$db_root_password -e "GRANT ALL ON *.* TO '$db_username'@'localhost';flush privileges;"
# Create database
mysql -uroot -p$db_root_password -e "CREATE DATABASE $db_name;"

# Create wordpress configuration file and update database value
cd /var/www/html
cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/$db_name/g" wp-config.php
sed -i "s/username_here/$db_username/g" wp-config.php
sed -i "s/password_here/$db_user_password/g" wp-config.php
cat <<EOF >>/var/www/html/wp-config.php

define( 'FS_METHOD', 'direct' );
define('WP_MEMORY_LIMIT', '256M');

EOF

# Change permission of /var/www/html/
chown -R ubuntu:www-data /var/www/html
chmod -R 774 /var/www/html
rm /var/www/html/index.html
#  enable .htaccess files in Apache config using sed command
sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/apache2/apache2.conf

# restart apache

systemctl restart apache2
