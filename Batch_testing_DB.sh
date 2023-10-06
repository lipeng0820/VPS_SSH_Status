#!/bin/bash

# 检测系统类型并安装mariadb-client
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VERSION=$VERSION_ID
else
    OS=$(uname -s)
    VERSION=$(uname -r)
fi

if ! command -v mysql &> /dev/null; then
    echo "mariadb-client 未安装，正在安装..."
    case $OS in
        Debian|Ubuntu)
            sudo apt update
            sudo apt install -y mariadb-client
            ;;
        CentOS)
            if [ "$VERSION" == "7" ]; then
                sudo yum install -y mariadb
            else
                sudo dnf install -y mariadb
            fi
            ;;
        *)
            echo "不支持的操作系统: $OS"
            exit 1
            ;;
    esac
fi

# 获取IPv4和IPv6地址
IPV4=$(curl -s https://myip4.ipip.net || curl -s https://ddns.oray.com/checkip || curl -s https://ip.3322.net || curl -s https://4.ipw.cn)
[ -z "$IPV4" ] && IPV4="NULL"

IPV6=$(curl -s https://speed.neu6.edu.cn/getIP.php || curl -s https://v6.ident.me || curl -s https://6.ipw.cn)
[ -z "$IPV6" ] && IPV6="NULL"

# 获取系统当前的SSH尝试登录次数
LOGIN_ATTEMPTS=$(grep "Failed password" /var/log/auth.log | wc -l)

# 检查当前的登录模式
if grep -q "PasswordAuthentication yes" /etc/ssh/sshd_config; then
    LOGIN_MODE="SSH登录"
else
    LOGIN_MODE="私钥登录"
fi

# 随机等待，用户按键跳过
echo -n "默认等待 $((1 + RANDOM % 100)) 秒，或按任意键立即启动..."
read -t 1 -n 1 && echo

# 将数据写入数据库
mysql -h dbs-connect-cn-0.ip.parts -u vedbs_2149 -p2IecH8HqMi Freed00r2023 -e \
"INSERT INTO FREED00R_SSH (login_mode, ip_address, login_attempts) VALUES ('$LOGIN_MODE', CONCAT('$IPV4', '/', '$IPV6'), $LOGIN_ATTEMPTS);"

echo "数据已写入数据库"
