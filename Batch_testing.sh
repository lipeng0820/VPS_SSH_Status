#!/bin/bash

API_DEV_KEY="0351ffead849217e8338e771eb5b3dbd"
API_USER_NAME="lipeng0820"
API_USER_PASSWORD="Kwaient2023!"

# 获取api_user_key
API_USER_KEY=$(curl -s -d "api_dev_key=$API_DEV_KEY" -d "api_user_name=$API_USER_NAME" -d "api_user_password=$API_USER_PASSWORD" -d "api_option=userdetails" "https://pastebin.com/api/api_login.php")

# 获取IPv4地址
IPV4=$(curl -s https://myip4.ipip.net || curl -s https://ddns.oray.com/checkip || curl -s https://ip.3322.net || curl -s https://4.ipw.cn)
[ -z "$IPV4" ] && IPV4="无"

# 获取IPv6地址
IPV6=$(curl -s https://speed.neu6.edu.cn/getIP.php || curl -s https://v6.ident.me || curl -s https://6.ipw.cn)
[ -z "$IPV6" ] && IPV6="无"

# 获取SSH尝试登录次数
SSH_ATTEMPTS=$(grep sshd.\*Failed /var/log/auth.log | wc -l)

# 检查登录模式
if grep -q "PasswordAuthentication no" /etc/ssh/sshd_config; then
    LOGIN_MODE="私钥登录"
else
    LOGIN_MODE="SSH登录"
fi

# 准备要上传的内容
LOG_CONTENT="IPV4地址: $IPV4
IPV6地址: $IPV6
SSH尝试登录次数: $SSH_ATTEMPTS
登录模式: $LOGIN_MODE"

API_OPTION="paste"
API_PASTE_NAME="VPS_SSH_Status_$(echo $IPV4 | tr '.' '_')"
API_PASTE_EXPIRE_DATE="1H"
API_PASTE_PRIVATE="1"

# 上传到Pastebin
PASTE_URL=$(curl -s -X POST -d "api_dev_key=$API_DEV_KEY" -d "api_option=$API_OPTION" -d "api_user_key=$API_USER_KEY" -d "api_paste_code=$LOG_CONTENT" -d "api_paste_name=$API_PASTE_NAME" -d "api_paste_expire_date=$API_PASTE_EXPIRE_DATE" -d "api_paste_private=$API_PASTE_PRIVATE" "https://pastebin.com/api/api_post.php")

# 显示上传结果
echo "日志已上传。您可以在以下URL查看它："
echo "$PASTE_URL"
