#!/bin/bash

# Проверка на запуск от root
if [ "$(id -u)" -ne 0 ]; then
  echo "Этот скрипт должен быть запущен с правами root!" >&2
  exit 1
fi

# Параметры установки
MOODLE_VERSION="4.3.1"
MOODLE_DIR="/var/www/html/moodle"
MOODLE_DATA="/var/moodledata"
DB_NAME="moodledb"
DB_USER="moodle"
DB_PASS="P@ssw0rd"
ADMIN_PASS="P@ssw0rd"
WORKSTATION_NUMBER="1"  # Номер рабочего места (измените по необходимости)

# 1. Обновление системы и установка зависимостей
echo "🔹 Обновление пакетов и установка зависимостей..."
apt-get update
apt-get upgrade -y
apt-get install -y \
    apache2 \
    mariadb-server mariadb-client \
    php php-cli php-curl php-zip php-xml php-mbstring php-gd php-intl php-soap \
    php-mysqlnd php-pgsql php-ldap php-json php-iconv php-openssl \
    git unzip curl wget

# 2. Настройка MariaDB
echo "🔹 Настройка MariaDB..."
systemctl enable mariadb --now
mysql -e "CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# 3. Загрузка и распаковка Moodle
echo "🔹 Загрузка Moodle ${MOODLE_VERSION}..."
wget -O /tmp/moodle.tgz "https://download.moodle.org/download.php/direct/stable${MOODLE_VERSION%.*}/moodle-${MOODLE_VERSION}.tgz"
mkdir -p "${MOODLE_DIR}"
tar -xzf /tmp/moodle.tgz -C "${MOODLE_DIR}" --strip-components=1
rm /tmp/moodle.tgz

# 4. Настройка прав доступа
echo "🔹 Настройка прав доступа..."
chown -R www-data:www-data "${MOODLE_DIR}"
chmod -R 755 "${MOODLE_DIR}"
mkdir -p "${MOODLE_DATA}"
chown -R www-data:www-data "${MOODLE_DATA}"
chmod -R 777 "${MOODLE_DATA}"

# 5. Настройка Apache
echo "🔹 Настройка Apache..."
cat > /etc/apache2/sites-available/moodle.conf <<EOF
<VirtualHost *:80>
    ServerAdmin admin@example.com
    DocumentRoot ${MOODLE_DIR}
    ServerName localhost

    <Directory ${MOODLE_DIR}>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/moodle_error.log
    CustomLog \${APACHE_LOG_DIR}/moodle_access.log combined
</VirtualHost>
EOF

a2ensite moodle.conf
a2dissite 000-default.conf
a2enmod rewrite
systemctl restart apache2

# 6. Настройка cron для Moodle
echo "🔹 Настройка cron-заданий..."
(crontab -l 2>/dev/null; echo "* * * * * /usr/bin/php ${MOODLE_DIR}/admin/cli/cron.php >/dev/null") | crontab -

# 7. Создание файла конфигурации Moodle
echo "🔹 Создание config.php..."
cat > "${MOODLE_DIR}/config.php" <<EOF
<?php
unset(\$CFG);
global \$CFG;
\$CFG = new stdClass();

\$CFG->dbtype    = 'mariadb';
\$CFG->dblibrary = 'native';
\$CFG->dbhost    = 'localhost';
\$CFG->dbname    = '${DB_NAME}';
\$CFG->dbuser    = '${DB_USER}';
\$CFG->dbpass    = '${DB_PASS}';
\$CFG->prefix    = 'mdl_';
\$CFG->dboptions = array(
  'dbpersist' => 0,
  'dbport' => '',
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_unicode_ci',
);

\$CFG->wwwroot   = 'http://$(hostname -I | awk '{print $1}')';
\$CFG->dataroot  = '${MOODLE_DATA}';
\$CFG->admin     = 'admin';
\$CFG->directorypermissions = 0777;

require_once(__DIR__ . '/lib/setup.php');
EOF

# 8. Установка Moodle через CLI
echo "🔹 Установка Moodle через командную строку..."
sudo -u www-data php "${MOODLE_DIR}/admin/cli/install.php" \
    --lang=ru \
    --wwwroot="http://$(hostname -I | awk '{print $1}')" \
    --dataroot="${MOODLE_DATA}" \
    --dbtype="mariadb" \
    --dbhost="localhost" \
    --dbname="${DB_NAME}" \
    --dbuser="${DB_USER}" \
    --dbpass="${DB_PASS}" \
    --prefix="mdl_" \
    --fullname="Moodle ${WORKSTATION_NUMBER}" \
    --shortname="${WORKSTATION_NUMBER}" \
    --adminuser="admin" \
    --adminpass="${ADMIN_PASS}" \
    --non-interactive \
    --agree-license

# 9. Настройка главной страницы
echo "🔹 Настройка главной страницы..."
mysql -u "${DB_USER}" -p"${DB_PASS}" "${DB_NAME}" <<MYSQL_SCRIPT
UPDATE mdl_config SET value='${WORKSTATION_NUMBER}' WHERE name='fullname';
UPDATE mdl_config SET value='${WORKSTATION_NUMBER}' WHERE name='shortname';
MYSQL_SCRIPT

# 10. Генерация отчета
echo "🔹 Генерация отчета..."
REPORT_FILE="/root/moodle_install_report.txt"
cat > "${REPORT_FILE}" <<EOF
Отчет об установке Moodle
========================

1. Основные параметры:
- Версия Moodle: ${MOODLE_VERSION}
- Номер рабочего места: ${WORKSTATION_NUMBER}
- Директория установки: ${MOODLE_DIR}
- Директория данных: ${MOODLE_DATA}

2. Настройки базы данных:
- Имя базы данных: ${DB_NAME}
- Пользователь БД: ${DB_USER}
- Пароль БД: ${DB_PASS}

3. Учетные данные администратора:
- Логин: admin
- Пароль: ${ADMIN_PASS}

4. Доступ к системе:
- URL: http://$(hostname -I | awk '{print $1}')
EOF

echo -e "\n\033[1;32m✅ Установка завершена!\033[0m"
echo "=============================================="
echo "Отчет сохранен в: ${REPORT_FILE}"
echo "Доступ к системе: http://$(hostname -I | awk '{print $1}')"
echo "Логин администратора: admin"
echo "Пароль администратора: ${ADMIN_PASS}"
echo "=============================================="
