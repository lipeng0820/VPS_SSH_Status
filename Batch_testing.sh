#!/bin/bash

# 获取系统当前的SSH尝试登录次数
LOGIN_ATTEMPTS=$(grep "Failed password" /var/log/auth.log | wc -l)

# 检查当前的登录模式
if grep -q "PasswordAuthentication yes" /etc/ssh/sshd_config; then
    LOGIN_MODE="SSH登录"
else
    LOGIN_MODE="私钥登录"
fi

# 获取公共IP地址
IP_ADDR=$(curl -sSL http://httpbin.org/ip | grep -oP '"origin": "\K[^"]+')

# 输出到日志文件
echo "IP地址: $IP_ADDR" > "VPS_ssh_status_${IP_ADDR//./_}.log"
echo "SSH尝试登录次数: $LOGIN_ATTEMPTS" >> "VPS_ssh_status_${IP_ADDR//./_}.log"
echo "登录模式: $LOGIN_MODE" >> "VPS_ssh_status_${IP_ADDR//./_}.log"

# 使用curl上传日志文件到网盘
curl -k -F "file=@VPS_ssh_status_${IP_ADDR//./_}.log" \
    -F "token=vy7v4ahy1uwt1witoqdv" \
    -F "model=2" \
    -F "mrid=65203924949e3" \
    -X POST "https://tmp-cli.vx-cdn.com/app/upload_cli"
