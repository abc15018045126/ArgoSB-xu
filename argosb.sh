#!/bin/sh
export LANG=en_US.UTF-8
[ -z "${vmpt+x}" ] || { vmp=yes; vmag=yes; } 
[ -z "${warp+x}" ] || wap=yes
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -q 'agsb/x' || pgrep -f 'agsb/x' >/dev/null 2>&1; then
if [ "$1" = "rep" ]; then
[ "$vmp" = yes ] || { echo "提示：重置协议参数有误，请自查！💣"; exit; }
fi
else
[ "$1" = "del" ] || [ "$vmp" = yes ] || { echo "提示：未安装ArgoSB脚本，请在脚本前至少设置一个协议变量哦，再见！💣"; exit; }
fi
export uuid=${uuid:-''}
export port_vm_ws=${vmpt:-''}
export cdnym=${cdnym:-''}
export argo=yes
export ARGO_DOMAIN=${agn:-''}
export ARGO_AUTH=${agk:-''}
export ippz=${ippz:-''}
export ipyx=${ipyx:-''}
export warp=${warp:-''}
export name=${name:-''}
showmode(){
echo "ArgoSB脚本项目地址：https://github.com/yonggekkk/ArgoSB"
echo "主脚本：bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh)"
echo "显示节点信息命令：agsb list"
echo "更换代理协议变量组命令：自定义vmpt等变量 agsb rep"
echo "重启脚本命令：agsb res"
echo "卸载脚本命令：agsb del"
echo "双栈VPS显示IPv4节点配置命令：ippz=4 agsb list"
echo "双栈VPS显示IPv6节点配置命令：ippz=6 agsb list"
echo "---------------------------------------------------------"
echo
}
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "甬哥Github项目 ：github.com/yonggekkk"
echo "甬哥Blogger博客 ：ygkkk.blogspot.com"
echo "甬哥YouTube频道 ：www.youtube.com/@ygkkk"
echo "ArgoSB一键无交互小钢炮脚本💣 (VMess + Argo Tunnel Edition)"
echo "当前版本：V25.8.21-Simplified"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
hostname=$(uname -a | awk '{print $2}')
op=$(cat /etc/redhat-release 2>/dev/null || cat /etc/os-release 2>/dev/null | grep -i pretty_name | cut -d \" -f2)
[ -z "$(systemd-detect-virt 2>/dev/null)" ] && vi=$(virt-what 2>/dev/null) || vi=$(systemd-detect-virt 2>/dev/null)
case $(uname -m) in
aarch64) cpu=arm64;;
x86_64) cpu=amd64;;
*) echo "目前脚本不支持$(uname -m)架构" && exit
esac
mkdir -p "$HOME/agsb"
warpcheck(){
wgcfv6=$(curl -s6m5 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)
wgcfv4=$(curl -s4m5 https://www.cloudflare.com/cdn-cgi/trace -k | grep warp | cut -d= -f2)
}
v4v6(){
v4=$(curl -s4m5 icanhazip.com -k)
v6=$(curl -s6m5 icanhazip.com -k)
}
warpsx(){
if [ -n "$name" ]; then
sxname=$name-
echo "$sxname" > "$HOME/agsb/name"
echo
echo "所有节点名称前缀：$name"
fi
v4v6
if echo "$v6" | grep -q '^2a09' || echo "$v4" | grep -q '^104.28'; then
xouttag=direct
wap=warpargo
echo
echo "请注意：你已安装了warp"
else
if [ "$wap" != yes ]; then
xouttag=direct
wap=warpargo
elif [ "$warp" = "" ] || [ "$warp" = "yes" ] || [ "$warp" = "x" ]; then
xouttag=warp-out
wap=warp
echo
echo "所有内核协议添加warp全局出站"
else
xouttag=direct
wap=warpargo
fi
fi
if [ "$ipyx" = "" ]; then
xrip='ForceIP'
echo
elif [ "$ipyx" = "64" ]; then
xrip='ForceIPv6v4'
echo
echo "所有节点IPV6优先"
elif [ "$ipyx" = "46" ]; then
xrip='ForceIPv4v6'
echo
echo "所有节点IPV4优先"
elif [ "$ipyx" = "6" ]; then
xrip='ForceIPv6'
echo
echo "所有节点仅IPV6"
elif [ "$ipyx" = "4" ]; then
xrip='ForceIPv4'
echo
echo "所有节点仅IPV4"
else
xrip='ForceIP'
echo
fi
}
insuuid(){
if [ -z "$uuid" ] && [ ! -e "$HOME/agsb/uuid" ]; then
uuid=$("$HOME/agsb/xray" uuid)
echo "$uuid" > "$HOME/agsb/uuid"
elif [ -n "$uuid" ]; then
echo "$uuid" > "$HOME/agsb/uuid"
fi
uuid=$(cat "$HOME/agsb/uuid")
echo "UUID密码：$uuid"
}
installxray(){
echo
echo "=========启用xray内核========="
if [ ! -e "$HOME/agsb/xray" ]; then
curl -Lo "$HOME/agsb/xray" -# --retry 2 https://github.com/yonggekkk/ArgoSB/releases/download/argosbx/xray-$cpu
chmod +x "$HOME/agsb/xray"
sbcore=$("$HOME/agsb/xray" version 2>/dev/null | awk '/^Xray/{print $2}')
echo "已安装Xray正式版内核：$sbcore"
fi
cat > "$HOME/agsb/xr.json" <<EOF
{
  "log": {
    "access": "/dev/null",
    "error": "/dev/null",
    "loglevel": "none"
  },
  "inbounds": [
EOF
insuuid
}

xrsbvm(){
if [ -n "$vmp" ]; then
vmp=vmpt
if [ -z "$port_vm_ws" ] && [ ! -e "$HOME/agsb/port_vm_ws" ]; then
port_vm_ws=$(shuf -i 10000-65535 -n 1)
echo "$port_vm_ws" > "$HOME/agsb/port_vm_ws"
elif [ -n "$port_vm_ws" ]; then
echo "$port_vm_ws" > "$HOME/agsb/port_vm_ws"
fi
port_vm_ws=$(cat "$HOME/agsb/port_vm_ws")
echo "Vmess-ws端口：$port_vm_ws"
if [ -n "$cdnym" ]; then
echo "$cdnym" > "$HOME/agsb/cdnym"
echo "80系CDN或者回源CDN的host域名 (确保IP已解析在CF域名)：$cdnym"
fi
cat >> "$HOME/agsb/xr.json" <<EOF
        {
            "tag": "vmess-xr",
            "listen": "::",
            "port": ${port_vm_ws},
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${uuid}"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                  "path": "${uuid}-vm"
            }
        },
            "sniffing": {
            "enabled": true,
            "destOverride": ["http", "tls", "quic"],
            "metadataOnly": false
            }
         }
EOF
else
vmp=vmptargo
fi
}

xrsbout(){
if [ -e "$HOME/agsb/xr.json" ]; then
cat >> "$HOME/agsb/xr.json" <<EOF
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct",
      "settings": {
      "domainStrategy":"${xrip}"
     }
    },
    {
      "tag": "warp-out",
      "protocol": "wireguard",
      "settings": {
        "secretKey": "COAYqKrAXaQIGL8+Wkmfe39r1tMMR80JWHVaF443XFQ=",
        "address": [
          "172.16.0.2/32",
          "2606:4700:110:8eb1:3b27:e65e:3645:97b0/128"
        ],
        "peers": [
          {
            "publicKey": "bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
            "allowedIPs": [
              "0.0.0.0/0",
              "::/0"
            ],
            "endpoint": "${xendip}:2408"
          }
        ],
        "reserved": [134, 63, 85],
        "domainStrategy":"${xrip}"
        }
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "network": "tcp,udp",
        "outboundTag": "${xouttag}"
      }
    ]
  }
}
EOF
nohup "$HOME/agsb/xray" run -c "$HOME/agsb/xr.json" >/dev/null 2>&1 &
fi
}
killstart(){
for P in /proc/[0-9]*; do if [ -L "$P/exe" ]; then TARGET=$(readlink -f "$P/exe" 2>/dev/null); if echo "$TARGET" | grep -qE '/agsb/c|/agsb/x'; then PID=$(basename "$P"); kill "$PID" 2>/dev/null; fi; fi; done
kill -15 $(pgrep -f 'agsb/c' 2>/dev/null) $(pgrep -f 'agsb/x' 2>/dev/null) >/dev/null 2>&1
nohup $HOME/agsb/xray run -c $HOME/agsb/xr.json >/dev/null 2>&1 &
if [ -e "$HOME/agsb/sbargotoken.log" ]; then
nohup $HOME/agsb/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token $(cat $HOME/agsb/sbargotoken.log 2>/dev/null) >/dev/null 2>&1 &
else
if [ -e "$HOME/agsb/xr.json" ] && [ -e "$HOME/agsb/argo.log" ]; then
nohup $HOME/agsb/cloudflared tunnel --url http://localhost:$(grep -A2 vmess-xr $HOME/agsb/xr.json | tail -1 | tr -cd 0-9) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsb/argo.log 2>&1 &
fi
fi
sleep 6
}
ins(){
installxray
xrsbvm
warpsx
xrsbout
if [ -n "$argo" ] && [ -n "$vmag" ]; then
echo
echo "=========启用Cloudflared-argo内核========="
if [ ! -e "$HOME/agsb/cloudflared" ]; then
argocore=$(curl -Ls https://data.jsdelivr.com/v1/package/gh/cloudflare/cloudflared | grep -Eo '"[0-9.]+"' | sed -n 1p | tr -d '",')
echo "下载Cloudflared-argo最新正式版内核：$argocore"
curl -Lo "$HOME/agsb/cloudflared" -# --retry 2 https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$cpu
chmod +x "$HOME/agsb/cloudflared"
fi
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ]; then
name='固定'
nohup "$HOME/agsb/cloudflared" tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token "${ARGO_AUTH}" >/dev/null 2>&1 &
echo "${ARGO_DOMAIN}" > "$HOME/agsb/sbargoym.log"
echo "${ARGO_AUTH}" > "$HOME/agsb/sbargotoken.log"
else
name='临时'
nohup "$HOME/agsb/cloudflared" tunnel --url http://localhost:"${port_vm_ws}" --edge-ip-version auto --no-autoupdate --protocol http2 > "$HOME/agsb/argo.log" 2>&1 &
fi
echo "申请Argo$name隧道中……请稍等"
sleep 8
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ]; then
argodomain=$(cat "$HOME/agsb/sbargoym.log" 2>/dev/null)
else
argodomain=$(grep -a trycloudflare.com "$HOME/agsb/argo.log" 2>/dev/null | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
fi
if [ -n "${argodomain}" ]; then
echo "Argo$name隧道申请成功"
else
echo "Argo$name隧道申请失败，请稍后再试"
fi
fi
echo
if find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -q 'agsb/x' || pgrep -f 'agsb/x' >/dev/null 2>&1 ; then
[ -f ~/.bashrc ] || touch ~/.bashrc
sed -i '/yonggekkk/d' ~/.bashrc
echo "if ! find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -q 'agsb/x' && ! pgrep -f 'agsb/x' >/dev/null 2>&1; then echo '检测到系统可能中断过，建议在SSH对话框输入 reboot 重启下服务器。现在自动执行ArgoSB脚本的节点恢复操作，请稍等……'; sleep 6; export cdnym=\"${cdnym}\" name=\"${name}\" ipyx=\"${ipyx}\" ippz=\"${ippz}\" uuid=\"${uuid}\" warp=\"${warp}\" vmpt=\"${port_vm_ws}\" agn=\"${ARGO_DOMAIN}\" agk=\"${ARGO_AUTH}\"; bash <(curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh); fi" >> ~/.bashrc
COMMAND="agsb"
SCRIPT_PATH="$HOME/bin/$COMMAND"
mkdir -p "$HOME/bin"
curl -Ls https://raw.githubusercontent.com/yonggekkk/argosb/main/argosb.sh > "$SCRIPT_PATH"
chmod +x "$SCRIPT_PATH"
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
grep -qxF 'source ~/.bashrc' ~/.bash_profile 2>/dev/null || echo 'source ~/.bashrc' >> ~/.bash_profile
. ~/.bashrc 2>/dev/null
crontab -l > /tmp/crontab.tmp 2>/dev/null
sed -i '/agsb\/xray/d' /tmp/crontab.tmp
echo '@reboot /bin/sh -c "nohup $HOME/agsb/xray run -c $HOME/agsb/xr.json >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
sed -i '/agsb\/cloudflared/d' /tmp/crontab.tmp
if [ -n "$argo" ] && [ -n "$vmag" ]; then
if [ -n "${ARGO_DOMAIN}" ] && [ -n "${ARGO_AUTH}" ]; then
echo '@reboot /bin/sh -c "nohup $HOME/agsb/cloudflared tunnel --no-autoupdate --edge-ip-version auto --protocol http2 run --token $(cat $HOME/agsb/sbargotoken.log 2>/dev/null) >/dev/null 2>&1 &"' >> /tmp/crontab.tmp
else
echo '@reboot /bin/sh -c "nohup $HOME/agsb/cloudflared tunnel --url http://localhost:$(grep -A2 vmess-xr $HOME/agsb/xr.json | tail -1 | tr -cd 0-9) --edge-ip-version auto --no-autoupdate --protocol http2 > $HOME/agsb/argo.log 2>&1 &"' >> /tmp/crontab.tmp
fi
fi
crontab /tmp/crontab.tmp 2>/dev/null
rm /tmp/crontab.tmp
echo "ArgoSB脚本进程启动成功，安装完毕" && sleep 2
else
echo "ArgoSB脚本进程未启动，安装失败" && exit
fi
}
cip(){
ipbest(){
serip=$(curl -s4m5 icanhazip.com -k || curl -s6m5 icanhazip.com -k)
if echo "$serip" | grep -q ':'; then
server_ip="[$serip]"
echo "$server_ip" > "$HOME/agsb/server_ip.log"
else
server_ip="$serip"
echo "$server_ip" > "$HOME/agsb/server_ip.log"
fi
}
ipchange(){
v4v6
if [ -z "$v4" ]; then
vps_ipv4='无IPV4'
vps_ipv6="$v6"
elif [ -n "$v4" ] && [ -n "$v6" ]; then
vps_ipv4="$v4"
vps_ipv6="$v6"
else
vps_ipv4="$v4"
vps_ipv6='无IPV6'
fi
if echo "$v6" | grep -q '^2a09'; then
w6="【WARP】"
fi
if echo "$v4" | grep -q '^104.28'; then
w4="【WARP】"
fi
echo
echo "=========当前服务器本地IP情况========="
echo "本地IPV4地址：$vps_ipv4 $w4"
echo "本地IPV6地址：$vps_ipv6 $w6"
echo
sleep 2
if [ "$ippz" = "4" ]; then
if [ -z "$v4" ]; then
ipbest
else
server_ip="$v4"
echo "$server_ip" > "$HOME/agsb/server_ip.log"
fi
elif [ "$ippz" = "6" ]; then
if [ -z "$v6" ]; then
ipbest
else
server_ip="[$v6]"
echo "$server_ip" > "$HOME/agsb/server_ip.log"
fi
else
ipbest
fi
}
warpcheck
if ! echo "$wgcfv4" | grep -qE 'on|plus' && ! echo "$wgcfv6" | grep -qE 'on|plus'; then
ipchange
else
systemctl stop wg-quick@wgcf >/dev/null 2>&1
kill -15 $(pgrep warp-go) >/dev/null 2>&1 && sleep 2
ipchange
systemctl start wg-quick@wgcf >/dev/null 2>&1
systemctl restart warp-go >/dev/null 2>&1
systemctl enable warp-go >/dev/null 2>&1
systemctl start warp-go >/dev/null 2>&1
fi
rm -rf "$HOME/agsb/jh.txt"
uuid=$(cat "$HOME/agsb/uuid")
server_ip=$(cat "$HOME/agsb/server_ip.log")
sxname=$(cat "$HOME/agsb/name" 2>/dev/null)
vmcdnym=$(cat "$HOME/agsb/cdnym" 2>/dev/null)
echo "*********************************************************"
echo "*********************************************************"
echo "ArgoSB脚本输出节点配置如下："
echo
case "$server_ip" in
104.28*|\[2a09*) echo "检测到有WARP的IP作为客户端地址 (104.28或者2a09开头的IP)，请把客户端地址上的WARP的IP手动更换为VPS本地IPV4或者IPV6地址" && sleep 3 ;;
esac
echo
if grep vmess-xr "$HOME/agsb/xr.json" >/dev/null 2>&1; then
echo "💣【 vmess-ws 】节点信息如下："
port_vm_ws=$(cat "$HOME/agsb/port_vm_ws")
vm_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-ws-$hostname\", \"add\": \"$server_ip\", \"port\": \"$port_vm_ws\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"www.bing.com\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vm_link" >> "$HOME/agsb/jh.txt"
echo "$vm_link"
echo
if [ -f "$HOME/agsb/cdnym" ]; then
echo "💣【 vmess-ws 】80系CDN或者回源CDN节点信息如下："
echo "注：优选IP地址或者端口可自行手动修改"
vm_cdn_link="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vm-ws-cdn-$hostname\", \"add\": \"104.16.0.0\", \"port\": \"80\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$vmcdnym\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vm_cdn_link" >> "$HOME/agsb/jh.txt"
echo "$vm_cdn_link"
echo
fi
fi
argodomain=$(cat "$HOME/agsb/sbargoym.log" 2>/dev/null)
[ -z "$argodomain" ] && argodomain=$(grep -a trycloudflare.com "$HOME/agsb/argo.log" 2>/dev/null | awk 'NR==2{print}' | awk -F// '{print $2}' | awk '{print $1}')
if [ -n "$argodomain" ]; then
vmatls_link1="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-443\", \"add\": \"104.16.0.0\", \"port\": \"443\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link1" >> "$HOME/agsb/jh.txt"
vmatls_link2="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-8443\", \"add\": \"104.17.0.0\", \"port\": \"8443\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link2" >> "$HOME/agsb/jh.txt"
vmatls_link3="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-2053\", \"add\": \"104.18.0.0\", \"port\": \"2053\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link3" >> "$HOME/agsb/jh.txt"
vmatls_link4="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-2083\", \"add\": \"104.19.0.0\", \"port\": \"2083\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link4" >> "$HOME/agsb/jh.txt"
vmatls_link5="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-2087\", \"add\": \"104.20.0.0\", \"port\": \"2087\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link5" >> "$HOME/agsb/jh.txt"
vmatls_link6="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-tls-argo-$hostname-2096\", \"add\": \"[2606:4700::0]\", \"port\": \"2096\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"tls\", \"sni\": \"$argodomain\", \"alpn\": \"\", \"fp\": \"\"}" | base64 -w0)"
echo "$vmatls_link6" >> "$HOME/agsb/jh.txt"
vma_link7="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-80\", \"add\": \"104.21.0.0\", \"port\": \"80\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link7" >> "$HOME/agsb/jh.txt"
vma_link8="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-8080\", \"add\": \"104.22.0.0\", \"port\": \"8080\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link8" >> "$HOME/agsb/jh.txt"
vma_link9="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-8880\", \"add\": \"104.24.0.0\", \"port\": \"8880\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link9" >> "$HOME/agsb/jh.txt"
vma_link10="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-2052\", \"add\": \"104.25.0.0\", \"port\": \"2052\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link10" >> "$HOME/agsb/jh.txt"
vma_link11="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-2082\", \"add\": \"104.26.0.0\", \"port\": \"2082\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link11" >> "$HOME/agsb/jh.txt"
vma_link12="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-2086\", \"add\": \"104.27.0.0\", \"port\": \"2086\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link12" >> "$HOME/agsb/jh.txt"
vma_link13="vmess://$(echo "{ \"v\": \"2\", \"ps\": \"${sxname}vmess-ws-argo-$hostname-2095\", \"add\": \"[2400:cb00:2049::0]\", \"port\": \"2095\", \"id\": \"$uuid\", \"aid\": \"0\", \"scy\": \"auto\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"$argodomain\", \"path\": \"/$uuid-vm?ed=2048\", \"tls\": \"\"}" | base64 -w0)"
echo "$vma_link13" >> "$HOME/agsb/jh.txt"
sbtk=$(cat "$HOME/agsb/sbargotoken.log" 2>/dev/null)
if [ -n "$sbtk" ]; then
nametn="当前Argo固定隧道token：$sbtk"
fi
argoshow=$(echo -e "Vmess主协议端口(Argo固定隧道端口)：$port_vm_ws\n当前Argo$name域名：$argodomain\n$nametn\n\n1、💣443端口的vmess-ws-tls-argo节点\n$vmatls_link1\n\n2、💣80端口的vmess-ws-argo节点\n$vma_link7\n")
fi
echo "---------------------------------------------------------"
echo "$argoshow"
echo "---------------------------------------------------------"
echo "聚合节点信息，请查看$HOME/agsb/jh.txt文件或者运行cat $HOME/agsb/jh.txt进行复制"
echo "---------------------------------------------------------"
echo "相关快捷方式如下：(首次安装成功后需重连SSH，agsb快捷方式才可生效)"
showmode
}
cleandel(){
for P in /proc/[0-9]*; do if [ -L "$P/exe" ]; then TARGET=$(readlink -f "$P/exe" 2>/dev/null); if echo "$TARGET" | grep -qE '/agsb/c|/agsb/x'; then PID=$(basename "$P"); kill "$PID" 2>/dev/null; fi; fi; done
kill -15 $(pgrep -f 'agsb/c' 2>/dev/null) $(pgrep -f 'agsb/x' 2>/dev/null) >/dev/null 2>&1
sed -i '/yonggekkk/d' ~/.bashrc
sed -i '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc
. ~/.bashrc 2>/dev/null
crontab -l > /tmp/crontab.tmp 2>/dev/null
sed -i '/agsb\/xray/d' /tmp/crontab.tmp
sed -i '/agsb\/cloudflared/d' /tmp/crontab.tmp
crontab /tmp/crontab.tmp 2>/dev/null
rm /tmp/crontab.tmp
rm -rf  "$HOME/bin/agsb"
}
if [ "$1" = "del" ]; then
cleandel
rm -rf "$HOME/agsb"
echo "卸载完成"
echo "欢迎继续使用甬哥侃侃侃ygkkk的ArgoSB一键无交互小钢炮脚本💣"
echo
showmode
exit
elif [ "$1" = "rep" ]; then
cleandel
rm -rf "$HOME/agsb"/{xr.json,sbargoym.log,sbargotoken.log,argo.log,cdnym,name}
echo "ArgoSB重置协议完成，开始更新相关协议变量……" && sleep 3
echo
elif [ "$1" = "list" ]; then
cip
exit
elif [ "$1" = "res" ]; then
killstart
sleep 5 && echo "重启完成"
exit
fi
if ! find /proc/*/exe -type l 2>/dev/null | grep -E '/proc/[0-9]+/exe' | xargs -r readlink 2>/dev/null | grep -q 'agsb/x' && ! pgrep -f 'agsb/x' >/dev/null 2>&1; then
for P in /proc/[0-9]*; do if [ -L "$P/exe" ]; then TARGET=$(readlink -f "$P/exe" 2>/dev/null); if echo "$TARGET" | grep -qE '/agsb/c|/agsb/x'; then PID=$(basename "$P"); kill "$PID" 2>/dev/null; fi; fi; done
kill -15 $(pgrep -f 'agsb/c' 2>/dev/null) $(pgrep -f 'agsb/x' 2>/dev/null) >/dev/null 2>&1
v4orv6(){
if [ -z "$(curl -s4m5 icanhazip.com -k)" ]; then
echo "检测到 纯IPV6 VPS，添加NAT64"
echo -e "nameserver 2a00:1098:2b::1\nnameserver 2a00:1098:2c::1" > /etc/resolv.conf
fi
if [ -n "$(curl -s6m5 icanhazip.com -k)" ]; then
sendip="2606:4700:d0::a29f:c001"
xendip="[2606:4700:d0::a29f:c001]"
else
sendip="162.159.192.1"
xendip="162.159.192.1"
fi
}
warpcheck
if ! echo "$wgcfv4" | grep -qE 'on|plus' && ! echo "$wgcfv6" | grep -qE 'on|plus'; then
v4orv6
else
systemctl stop wg-quick@wgcf >/dev/null 2>&1
kill -15 $(pgrep warp-go) >/dev/null 2>&1 && sleep 2
v4orv6
systemctl start wg-quick@wgcf >/dev/null 2>&1
systemctl restart warp-go >/dev/null 2>&1
systemctl enable warp-go >/dev/null 2>&1
systemctl start warp-go >/dev/null 2>&1
fi
echo "VPS系统：$op"
echo "CPU架构：$cpu"
echo "ArgoSB脚本未安装，开始安装…………" && sleep 2
setenforce 0 >/dev/null 2>&1
iptables -P INPUT ACCEPT >/dev/null 2>&1
iptables -P FORWARD ACCEPT >/dev/null 2>&1
iptables -P OUTPUT ACCEPT >/dev/null 2>&1
iptables -F >/dev/null 2>&1
netfilter-persistent save >/dev/null 2>&1
ins
cip
echo
else
echo "ArgoSB脚本已安装"
echo
echo "相关快捷方式如下："
showmode
exit
fi