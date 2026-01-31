#!/bin/sh

set -e

WP_PATH="/var/www/wordpress"

echo "Starting WordPress entrypoint..."

if [ ! -f "$WP_PATH/wp-config.php" ] && [ ! -f "$WP_PATH/index.php" ]; then
    echo "Initializing WordPress directory from image..."
    cp -r /tmp/wordpress/* "$WP_PATH/" 2>/dev/null || true
fi

echo "Waiting for MariaDB to be ready..."
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
    if mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -h ${MYSQL_HOST} -P ${MYSQL_PORT} -e "SELECT 1" > /dev/null 2>&1; then
        echo "MariaDB is ready!"
        break
    fi
    echo "Attempt $i/15..."
    sleep 2
done

if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "Creating wp-config.php..."
    cp "$WP_PATH/wp-config-sample.php" "$WP_PATH/wp-config.php"
fi

echo "Updating wp-config.php with environment variables..."
sed -i "s/define( *'DB_NAME'.*/define( 'DB_NAME', '${MYSQL_DATABASE}' );/" "$WP_PATH/wp-config.php"
sed -i "s/define( *'DB_USER'.*/define( 'DB_USER', '${MYSQL_USER}' );/" "$WP_PATH/wp-config.php"
sed -i "s/define( *'DB_PASSWORD'.*/define( 'DB_PASSWORD', '${MYSQL_PASSWORD}' );/" "$WP_PATH/wp-config.php"
sed -i "s/define( *'DB_HOST'.*/define( 'DB_HOST', '${MYSQL_HOST}:${MYSQL_PORT}' );/" "$WP_PATH/wp-config.php"
echo "wp-config.php configured successfully"

cd ${WP_PATH}
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress with WP-CLI..."
    
    wp core install \
        --url="${WP_URL}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root \
        --skip-email \
        
else
    echo "WordPress is already installed"
fi

echo "Updating WordPress URLs to match current configuration..."
wp option update home "${WP_URL}" --path=${WP_PATH} --allow-root
wp option update siteurl "${WP_URL}" --path=${WP_PATH} --allow-root
echo "WordPress URLs updated successfully!"

echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F