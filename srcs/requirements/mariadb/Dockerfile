FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    bash \
    mariadb-server \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld /var/lib/mysql \
 && chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY tools/entrypoint.sh /entrypoint.sh

RUN mkdir -p /etc/mysql/mariadb.conf.d

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]