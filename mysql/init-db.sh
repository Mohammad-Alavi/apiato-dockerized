#!/bin/sh

echo 'CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '\''$MYSQL_USER'\''@'\''%'\''; ' > /docker-entrypoint-initdb.d/init.sql;
echo 'CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE_TEST; GRANT ALL PRIVILEGES ON $MYSQL_DATABASE_TEST.* TO '\''$MYSQL_USER'\''@'\''%'\''; ' >> /docker-entrypoint-initdb.d/init.sql; /usr/local/bin/docker-entrypoint.sh  --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --default-authentication-plugin=mysql_native_password

#This is not used
#Can be used in docker composer file under mysql service
#Something like this
#    volumes:
#      - ./mysql/init:/docker-entrypoint-initdb.d
#      - ./mysql/init-db.sh:/init-db.sh
#    command: ["/bin/sh", "/init-db.sh"]


#mysql.env file is also not used! the db with default name and secret is create by `init` folder