#!/bin/bash

# 获取IP地址
IP_ADDRESS=$(curl -s ifconfig.me)

# 获取SSH登录尝试的次数
SSH_ATTEMPTS=$(grep "Failed password" /var/log/auth.log | wc -l)

# 检查登录模式
if grep -q "PasswordAuthentication yes" /etc/ssh/sshd_config; then
    LOGIN_MODE="SSH登录"
else
    LOGIN_MODE="私钥登录"
fi

# 创建日志
LOG_CONTENT="IP地址: $IP_ADDRESS
SSH尝试登录次数: $SSH_ATTEMPTS
登录模式: $LOGIN_MODE"

# 将日志上传到Pastebin
API_KEY="0351ffead849217e8338e771eb5b3dbd"
PASTE_NAME="VPS_Log_$IP_ADDRESS"

# 使用Pastebin的API上传日志
PASTE_URL=$(curl -s -X POST -d "api_dev_key=$API_KEY" -d "api_option=paste" -d "api_paste_name=$PASTE_NAME" -d "api_paste_code=$LOG_CONTENT" https://pastebin.com/api/api_post.php)

# 显示上传结果
echo "日志已上传。您可以在以下URL查看它："
echo "$PASTE_URL"
