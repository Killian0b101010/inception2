#!/bin/sh

set -e

MYSQL_DATA_DIR="/var/lib/mysql"

echo "Starting MariaDB entrypoint..."

if [ ! -f "$MYSQL_DATA_DIR/mysql_upgrade_info" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=$MYSQL_DATA_DIR
    echo "Data directory initialized!"
fi

echo "Starting MariaDB daemon for initialization on port ${MYSQL_PORT}..."
mysqld --user=mysql --port=${MYSQL_PORT} --skip-grant-tables &
MYSQL_PID=$!

echo "Waiting for MariaDB to start..."
for i in 1 2 3 4 5 6 7 8 9 10; do
    if mysqladmin -u root -P ${MYSQL_PORT} ping > /dev/null 2>&1; then
        echo "MariaDB is ready!"
        break
    fi
    echo "Attempt $i/10..."
    sleep 1
done

echo "Creating database and user..."
mysql -u root -P ${MYSQL_PORT} << EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

echo "Database initialization complete!"


kill $MYSQL_PID
wait $MYSQL_PID 2>/dev/null || true

sleep 1

echo "Starting MariaDB with grant tables enabled on port ${MYSQL_PORT}..."
exec mysqld --user=mysql --port=${MYSQL_PORT}