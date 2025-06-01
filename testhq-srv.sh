#!/bin/bash
apt-get install -y moodle moodle-apache2
apt-get install -y mariadb-server php8.2-mysqlnd-mysqli
systemctl enable --now mariadb
cat <<EOF > /tmp/modle.txt
CREATE DATABASE moodledb;
CREATE USER 'moodle'@'%' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL PRIVILEGES ON moodledb.* TO 'moodle'@'%' WITH GRANT OPTION;
EOF
cat /tmp/modle.txt
mariadb -u root
sleep 5
mariadb -u root -e "CREATE DATABASE moodledb;"
sleep 5
mariadb -u root -e "CREATE USER 'moodle'@'%' IDENTIFIED BY 'P@ssw0rd';"
sleep 5
mariadb -u root -e "GRANT ALL PRIVILEGES ON moodledb.* TO 'moodle'@'%' WITH GRANT OPTION;"
sleep 5
sed -i "s/; max_input_vars = 1000/max_input_vars = 5000/g" /etc/php/8.2/apache2-mod_php/php.ini
systemctl enable --now httpd2
