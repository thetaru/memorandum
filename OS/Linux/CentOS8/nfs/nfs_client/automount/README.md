# 自動マウントについて
## ■ 前提条件
|設定項目|設定値|
|:---|:---|
|NFSサーバ|nfs-srv|
|共有ディレクトリ|/mnt/data|
|マウントポイント|/mnt/data|

## ■ fstabの設定
```
### NFSv3以上
nfs-srv:/mnt/data          /mnt/data         nfs noauto,noatime,rsize=32768,wsize=32768 0 0

### NFSv3のみ
nfs-srv:/mnt/data          /mnt/data         nfs v3,noauto,noatime,rsize=32768,wsize=32768 0 0

### NFSv4のみ
nfs-srv:/mnt/data          /mnt/data         nfs4 noauto,noatime,rsize=32768,wsize=32768 0 0
```
※1 `noauto`マウントオプションはOS起動時に自動的に共有をマウントしないようします  
※2 mountコマンドでマウントしても共有できないので試験しようとして驚かないこと

## ■ cron(タイマー)の設定
### シェルの作成
NFSサーバに到達可能であることをチェックするスクリプトを作成し、cronを使って定期的に実行します。  
以下のシェルは`/usr/local/bin/auto_share`に格納します。
```sh
#!/bin/bash

function net_umount {
  umount -l -f $1 &>/dev/null
}

function net_mount {
  mountpoint -q $1 || mount $1
}

NET_MOUNTS=$(sed -e '/^.*#/d' -e '/^.*:/!d' -e 's/\t/ /g' /etc/fstab | tr -s " ")$'\n'b

printf %s "$NET_MOUNTS" | while IFS= read -r line
do
  SERVER=$(echo $line | cut -f1 -d":")
  MOUNT_POINT=$(echo $line | cut -f2 -d" ")

  # Check if server already tested
  if [[ "${server_ok[@]}" =~ "${SERVER}" ]]; then
    # The server is up, make sure the share are mounted
    net_mount $MOUNT_POINT
  elif [[ "${server_notok[@]}" =~ "${SERVER}" ]]; then
    # The server could not be reached, unmount the share
    net_umount $MOUNT_POINT
  else
    # Check if the server is reachable
    ping -c 1 "${SERVER}" &>/dev/null

    if [ $? -ne 0 ]; then
      server_notok[${#Unix[@]}]=$SERVER
      # The server could not be reached, unmount the share
      net_umount $MOUNT_POINT
    else
      server_ok[${#Unix[@]}]=$SERVER
      # The server is up, make sure the share are mounted
      net_mount $MOUNT_POINT
    fi
  fi
done
```
スクリプトに実行権限を付与します。
```
# chmod +x /usr/local/bin/auto_share
```
### タイマーの作成
以下のユニットファイルは`/etc/systemd/system/auto_share.timer`に格納します。  
今回のタイマーは1分毎にスクリプトを実行します。
```
[Unit]
Description=Check the network mounts

[Timer]
OnCalendar=*-*-* *:*:00

[Install]
WantedBy=timers.target
```

### サービスの作成
以下のユニットファイルは`/etc/systemd/system/auto_share.service`に格納します。
```
[Unit]
Description=Check the network mounts

[Service]
Type=simple
ExecStart=/usr/local/bin/auto_share

[Install]
WantedBy=multi-user.target
```

### サービスの有効化
```
# systemctl enable --now auto_share.service
# systemctl enable --now auto_share.timer
```
マウントポイントをumountした後、自動的にマウントされていることを確認できればOKです。
