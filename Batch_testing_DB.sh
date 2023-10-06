#!/bin/bash

# 检查并安装 mariadb-client
if ! command -v mysql &> /dev/null; then
    echo "mariadb-client 未安装，正在安装..."
    sudo apt update && sudo apt install -y mariadb-client
fi

# 获取系统当前的SSH尝试登录次数
LOGIN_ATTEMPTS=$(grep "Failed password" /var/log/auth.log | wc -l)

# 检查当前的登录模式
if grep -q "PasswordAuthentication yes" /etc/ssh/sshd_config; then
    LOGIN_MODE="SSH登录"
else
    LOGIN_MODE="私钥登录"
fi

# 获取IPv4和IPv6地址
IPV4=$(curl -s https://myip4.ipip.net || curl -s https://ddns.oray.com/checkip || curl -s https://ip.3322.net || curl -s https://4.ipw.cn)
[ -z "$IPV4" ] && IPV4="无"
IPV6=$(curl -s https://speed.neu6.edu.cn/getIP.php || curl -s https://v6.ident.me || curl -s https://6.ipw.cn)
[ -z "$IPV6" ] && IPV6="无"

# 组合IP地址
IP_ADDRESS="${IPV4}, ${IPV6}"

# 延迟执行脚本的时间段（为了避免所有服务器同时向数据库发起请求）
RANDOM_DELAY=$(shuf -i 1-10 -n 1)
echo "默认等待 $RANDOM_DELAY 秒，或按任意键立即启动..."
read -t "$RANDOM_DELAY" -n 1

# 连接数据库并插入数据
# 连接数据库并插入数据
DB_PASSWORD="aF3iOAURaf"
mysql -h dbs-connect-cn-0.ip.parts -u vedbs_2150 -p$DB_PASSWORD vedbs_2150 --default-character-set=utf8mb4 -e "INSERT INTO FREED00R_SSH (ip_address, login_attempts, login_mode) VALUES ('$IP_ADDRESS', $LOGIN_ATTEMPTS, '$LOGIN_MODE');"

echo "数据已写入数据库"
