#!/bin/bash
yum -y update
yum -y install mysql

cat <<EOF | bash
${SHELL_SCRIPT}
EOF

cat <<EOF >>/tmp/mysql-query.sql
${MYSQL_SCRIPT}
EOF

mysql 	--host=${DATABASE_ENDPOINT} \
		--port=${DATABASE_PORT} \
		--user=${DATABASE_USER} \
		--password='${DATABASE_PASSWORD}' \
		${DATABASE_NAME} \
		< /tmp/mysql-query.sql

# Hara-kiri (since instance_initiated_shutdown_behavior = "terminate")
shutdown
