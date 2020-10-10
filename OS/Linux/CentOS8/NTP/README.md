# NTPサーバ設定
# chronyの設定
```
pool xxx.xxx.xxx.xxx
stratumweight 0
driftfile /var/lib/chrony/drift
rtcsync
leapsecmode slew

deny all
allow 192.168.120
bindaddress 127.0.0.1
bindcmdaddress ::1
local stratum 10

#noclientlog
logchange 0.5
logdir /var/log/chrony
```
