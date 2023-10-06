#!/bin/bash

# 检查是否安装了mariadb-client
if ! command -v mysql &> /dev/null; then
    echo "mariadb-client 未安装，正在安装..."
    sudo apt update && sudo apt install -y mariadb-client
fi

# 随机等待时间，用于打散请求
SLEEP_TIME=$((RANDOM % 100 + 1))

echo "默认等待 $SLEEP_TIME 秒，或按任意键立即启动..."
read -t $SLEEP_TIME -n 1 && SLEEP_TIME=0
sleep $SLEEP_TIME

# 获取登录尝试次数、登录模式、IP地址
LOGIN_ATTEMPTS=$(grep "Failed password" /var/log/auth.log | wc -l)
if grep -q "PasswordAuthentication yes" /etc/ssh/sshd_config; then
    LOGIN_MODE="SSH登录"
else
    LOGIN_MODE="私钥登录"
fi
IPV4=$(curl -s https://myip4.ipip.net || curl -s https://ddns.oray.com/checkip || curl -s https://ip.3322.net || curl -s https://4.ipw.cn)
[ -z "$IPV4" ] && IPV4="无"
IPV6=$(curl -s https://speed.neu6.edu.cn/getIP.php || curl -s https://v6.ident.me || curl -s https://6.ipw.cn)
[ -z "$IPV6" ] && IPV6="无"

# 生成文件名并记录信息
FILENAME="VPS_ssh_status_${LOGIN_MODE}_${IPV4//./_}_${IPV6//:/_}_${LOGIN_ATTEMPTS}.log"
echo "IP地址: $IPV4" > "$FILENAME"
echo "SSH尝试登录次数: $LOGIN_ATTEMPTS" >> "$FILENAME"
echo "登录模式: $LOGIN_MODE" >> "$FILENAME"

# 将数据写入数据库
DB_HOST="dbs-cn-0.ip.parts"
DB_USER="vedbs_2149"
DB_PASS="2IecH8HqMi"
DB_NAME="your_db_name"  # 请提供数据库名称

mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME -e "\
INSERT INTO your_table_name (ip_address, ssh_attempts, login_mode) \
VALUES ('$IPV4', '$LOGIN_ATTEMPTS', '$LOGIN_MODE');"

echo "数据已写入数据库"