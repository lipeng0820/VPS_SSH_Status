#!/bin/bash

# 检查是否安装mariadb-client
if ! command -v mysql &> /dev/null; then
    echo "mariadb-client 未安装，正在安装..."
    sudo apt update && sudo apt install -y mariadb-client
fi

# 定义数据库连接变量
DB_HOST="dbs-connect-cn-0.ip.parts"
DB_USER="vedbs_2149"
DB_PASS="2IecH8HqMi"
DB_NAME="Freed00r2023"
TABLE_NAME="FREED00R_SSH"

# 连接数据库并检查表是否存在
if ! mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "USE $DB_NAME;"; then
    echo "数据库 $DB_NAME 不存在，正在创建..."
    mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "CREATE DATABASE $DB_NAME;"
fi

# 检查表是否存在
if ! mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "USE $DB_NAME; DESC $TABLE_NAME;"; then
    echo "表 $TABLE_NAME 不存在，正在创建..."
    mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "USE $DB_NAME; CREATE TABLE $TABLE_NAME (id INT AUTO_INCREMENT PRIMARY KEY, timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, ip_address VARCHAR(255), login_attempts INT, login_mode VARCHAR(255));"
fi

# 检查最后的时间戳
LAST_TIMESTAMP=$(mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -sN -e "USE $DB_NAME; SELECT timestamp FROM $TABLE_NAME ORDER BY timestamp DESC LIMIT 1;")
CURRENT_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

if [ ! -z "$LAST_TIMESTAMP" ]; then
    DIFF=$(($(date -d "$CURRENT_TIMESTAMP" +%s) - $(date -d "$LAST_TIMESTAMP" +%s)))
    if [ $DIFF -lt 3 ]; then
        SLEEP_TIME=$((3 - DIFF + RANDOM % 3))
        echo "等待 $SLEEP_TIME 秒..."
        sleep $SLEEP_TIME
    fi
fi

# 获取数据
LOGIN_ATTEMPTS=$(grep "Failed password" /var/log/auth.log | wc -l)
LOGIN_MODE=$(grep -q "PasswordAuthentication yes" /etc/ssh/sshd_config && echo "SSH登录" || echo "私钥登录")
IPV4=$(curl -s https://myip4.ipip.net || curl -s https://ddns.oray.com/checkip || curl -s https://ip.3322.net || curl -s https://4.ipw.cn)
[ -z "$IPV4" ] && IPV4="NULL"
IPV6=$(curl -s https://speed.neu6.edu.cn/getIP.php || curl -s https://v6.ident.me || curl -s https://6.ipw.cn)
[ -z "$IPV6" ] && IPV6="NULL"
IP_ADDRESS="${IPV4}, ${IPV6}"

# 插入数据到数据库
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "USE $DB_NAME; INSERT INTO $TABLE_NAME (ip_address, login_attempts, login_mode) VALUES ('$IP_ADDRESS', $LOGIN_ATTEMPTS, '$LOGIN_MODE');"

echo "数据已写入数据库"
