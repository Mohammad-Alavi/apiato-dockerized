FROM mysql:5.7

ENTRYPOINT sh -c "echo 'CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '\''$MYSQL_USER'\''@'\''%'\''; ' > /docker-entrypoint-initdb.d/init.sql; echo 'CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE_TEST; GRANT ALL PRIVILEGES ON $MYSQL_DATABASE_TEST.* TO '\''$MYSQL_USER'\''@'\''%'\''; ' >> /docker-entrypoint-initdb.d/init.sql; /usr/local/bin/docker-entrypoint.sh  --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --default-authentication-plugin=mysql_native_password"
