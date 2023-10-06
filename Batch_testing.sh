#!/bin/bash

# 尝试获取IPv4地址的接口列表
IPV4_SOURCES=("https://myip4.ipip.net" "https://ddns.oray.com/checkip" "https://ip.3322.net" "https://4.ipw.cn")

# 尝试获取IPv6地址的接口列表
IPV6_SOURCES=("https://speed.neu6.edu.cn/getIP.php" "https://v6.ident.me" "https://6.ipw.cn")

# 获取IP地址的函数
get_ip_address() {
    local SOURCES=("$@")
    for SOURCE in "${SOURCES[@]}"; do
        IP=$(curl -s $SOURCE)
        if [ -n "$IP" ]; then
            echo "$IP"
            return
        fi
    done
    echo "无"
}

# 获取IPv4和IPv6地址
IPV4_ADDRESS=$(get_ip_address "${IPV4_SOURCES[@]}")
IPV6_ADDRESS=$(get_ip_address "${IPV6_SOURCES[@]}")

# 获取SSH登录尝试的次数
SSH_ATTEMPTS=$(grep "Failed password" /var/log/auth.log | wc -l)

# 检查登录模式
if grep -q "PasswordAuthentication yes" /etc/ssh/sshd_config; then
    LOGIN_MODE="SSH登录"
else
    LOGIN_MODE="私钥登录"
fi

# 创建日志
LOG_CONTENT="IPv4地址: $IPV4_ADDRESS
IPv6地址: $IPV6_ADDRESS
SSH尝试登录次数: $SSH_ATTEMPTS
登录模式: $LOGIN_MODE"

# 使用Pastebin的API上传日志
API_DEV_KEY="0351ffead849217e8338e771eb5b3dbd"
API_OPTION="paste"
API_PASTE_NAME="VPS_Log_${IPV4_ADDRESS}_${IPV6_ADDRESS}"
API_PASTE_EXPIRE_DATE="1H"
API_PASTE_PRIVATE="1"

PASTE_URL=$(curl -s -X POST -d "api_dev_key=$API_DEV_KEY" -d "api_option=$API_OPTION" -d "api_paste_code=$LOG_CONTENT" -d "api_paste_name=$API_PASTE_NAME" -d "api_paste_expire_date=$API_PASTE_EXPIRE_DATE" -d "api_paste_private=$API_PASTE_PRIVATE" "https://pastebin.com/api/api_post.php")

# 显示上传结果
echo "日志已上传。您可以在以下URL查看它："
echo "$PASTE_URL"
