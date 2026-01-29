FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-curl \
    php7.4-gd \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*


RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www

RUN wget https://fr.wordpress.org/wordpress-6.1-fr_FR.tar.gz \
    && tar -xzf wordpress-6.1-fr_FR.tar.gz \
    && rm wordpress-6.1-fr_FR.tar.gz

RUN chown -R www-data:www-data /var/www/wordpress

RUN mkdir -p /tools

RUN mkdir -p /run/php

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY tools/entrypoint.sh /tools/entrypoint.sh

RUN chmod +x /tools/entrypoint.sh

ENTRYPOINT ["/tools/entrypoint.sh"]
