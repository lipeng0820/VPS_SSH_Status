#!/bin/bash

# 获取本机IP地址，并将"."替换为"_"
IP_ADDRESS=$(hostname -I | awk '{print $1}' | tr '.' '_')

# 检测SSH登录尝试的次数
TOTAL_ATTEMPTS=$(grep "Failed password" /var/log/auth.log | wc -l)

# 检测是否启用了SSH密码登录
if grep -q "PasswordAuthentication yes" /etc/ssh/sshd_config; then
    LOGIN_MODE="SSH登录"
else
    LOGIN_MODE="私钥登录"
fi

# 生成日志文件
LOG_FILE="/tmp/VPS_ssh_status_$IP_ADDRESS.log"

echo "SSH尝试登录次数: $TOTAL_ATTEMPTS" > $LOG_FILE
echo "登录模式: $LOGIN_MODE" >> $LOG_FILE

# 使用curl命令上传日志文件到网盘
curl -k -F "file=@$LOG_FILE" -F "token=vy7v4ahy1uwt1witoqdv" -F "model=2" -F "mrid=65203924949e3" -X POST "https://tmp-cli.vx-cdn.com/app/upload_cli"

# 删除临时日志文件
rm -f $LOG_FILE
