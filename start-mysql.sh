#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

export MYSQL_ROOT_USER="root"
export MYSQL_ROOT_PASSWORD="pass$USER$RANDOM"
export MYSQL_HOST="127.0.0.1"
export MYSQL_PORT="3307"
export MYSQL_DB="globalcode"

echo "Generated password is $MYSQL_ROOT_PASSWORD"

echo "Setting Quarkus variables"
export DATASOURCE_URL="jdbc:mysql://$MYSQL_HOST:$MYSQL_PORT/$MYSQL_DB"
export DATASOURCE_USERNAME=$MYSQL_ROOT_USER
export DATASOURCE_PASSWORD=$MYSQL_ROOT_PASSWORD
export DATASOURCE_KIND="mysql"
export HIBERNATE_ORM_DATABASE_GENERATION="none"

echo "Exporting variables to config file:"

export CONFIG_FILE="$SCRIPT_DIR/tdc-api/.env"

echo "" > $CONFIG_FILE
echo "QUARKUS_DATASOURCE_JDBC_URL=$DATASOURCE_URL" >> $CONFIG_FILE
echo "QUARKUS_DATASOURCE_USERNAME=$DATASOURCE_USERNAME" >> $CONFIG_FILE
echo "QUARKUS_DATASOURCE_PASSWORD=$DATASOURCE_PASSWORD" >> $CONFIG_FILE
echo "QUARKUS_DATASOURCE_DB_KIND=$DATASOURCE_KIND" >> $CONFIG_FILE
echo "QUARKUS.HIBERNATE_ORM_DATABASE_GENERATION=$HIBERNATE_ORM_DATABASE_GENERATION" >> $CONFIG_FILE

echo "[$CONFIG_FILE] [IntelliJ ENV]"
cat $CONFIG_FILE

#cp -a $SCRIPT_DIR/config $SCRIPT_DIR/tdc-api/target/


echo ""
echo "Starting mysql container"
docker run --rm \
  --name $MYSQL_DB \
  -p 0.0.0.0:$MYSQL_PORT:3306 \
  -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  -e MYSQL_DATABASE=$MYSQL_DB \
  -d mysql:latest

echo "Connect to mysql with:"
echo mysql --host=$MYSQL_HOST --port=$MYSQL_PORT -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DB



