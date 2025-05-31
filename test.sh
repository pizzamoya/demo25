#!/bin/bash
apt-get install -y apache2 apache2-{base,httpd-prefork,mod_php8.1,mods}
apt-get install -y php8.1 php8.1-{curl,fileinfo,fpm-fcgi,gd,intl,ldap,mbstring,mysqlnd,mysqlnd-mysqli,opcache,soap,sodium,xmlreader,xmlrpc,zip,openssl}
systemctl enable --now httpd2
apt-get install -y MySQL-server
systemctl enable --now mysqld
mysql -e "CREATE DATABASE moodledb DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql -e "CREATE USER 'moodle'@'localhost' IDENTIFIED WITH mysql_native_password BY 'P@ssw0rd';"
mysql -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON moodledb.* TO 'moodle'@'localhost';
mysql -e "EXIT;"
apt-get install -y git 
git clone git://git.moodle.org/moodle.git
cd moodle
git branch -a
git branch --track MOODLE_405_STABLE origin/MOODLE_405_STABLE
git checkout MOODLE_405_STABLE
cd ../
cp -R moodle /var/www/html/
mkdir /var/moodledata
chown -R apache2 /var/moodledata
chmod -R 777 /var/moodledata
chmod -R 0755 /var/www/html/moodle
chown -R apache2:apache2 /var/www/html/moodle
cat <<EOF > /etc/httpd2/conf/sites-available/moodle.conf
<VirtualHost *:80>
        ServerName au-team.irpo
        ServerAlias moodle.au-team.irpo
        DocumentRoot /var/www/html/moodle
        <Directory "/var/www/html/moodle">
                AllowOverride All
                Options -Indexes +FollowSymLinks
        </Directory>
</VirtualHost>
EOF
ln -s /etc/httpd2/conf/sites-available/moodle.conf /etc/httpd2/conf/sites-enabled/
apachectl configtest
sed -i "s/; max_input_vars = 1000/max_input_vars = 5000/g" /etc/php/8.1/apache2-mod_php/php.ini
systemctl restart httpd2



