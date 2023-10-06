#!/bin/bash

# 数据库参数
DB_HOST="dbs-cn-0.ip.parts"
DB_USER="vedbs_2149"
DB_PASS="2IecH8HqMi"
DB_NAME="YourDatabaseName"  # 请替换为您的数据库名

# 获取系统数据
LOGIN_ATTEMPTS=$(grep "Failed password" /var/log/auth.log | wc -l)
LOGIN_MODE=$(grep -q "PasswordAuthentication yes" /etc/ssh/sshd_config && echo "SSH登录" || echo "私钥登录")
IPV4=$(curl -s https://myip4.ipip.net || curl -s https://ddns.oray.com/checkip || curl -s https://ip.3322.net || curl -s https://4.ipw.cn)
[ -z "$IPV4" ] && IPV4="无"
IPV6=$(curl -s https://speed.neu6.edu.cn/getIP.php || curl -s https://v6.ident.me || curl -s https://6.ipw.cn)
[ -z "$IPV6" ] && IPV6="无"

# 将数据插入数据库
mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME -e "INSERT INTO YourTableName (ipv4, ipv6, login_attempts, login_mode) VALUES ('$IPV4', '$IPV6', $LOGIN_ATTEMPTS, '$LOGIN_MODE');"
