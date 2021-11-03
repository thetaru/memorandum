# ghettoVCB
ESXiでVMのスナップショットを定期的に自動取得します。
## ■ インストール
`https://github.com/lamw/ghettoVCB`よりパッケージ(ここでは、master.zip)をダウンロードし、ストレージにアップロードします。
```
[root@localhost:~] cd /vmfs/volumes/607992d2-4f597502-872e-1c697a0a1d34/backup
[root@localhost:(snip)] unzip master.zip
[root@localhost:(snip)] mkdir -p /usr/local/bin
[root@localhost:(snip)] chmod +x ghettoVCB-master/ghettoVCB.sh
[root@localhost:(snip)] mv ghettoVCB-master/ghettoVCB.sh /usr/local/bin
[root@localhost:(snip)] cd /usr/local/bin
```

## ■ 設定
必要そうなパラメータを抜粋しました。
### VM_BACKUP_VOLUME
バックアップ先ディレクトリの指定をします。
### VM_BACKUP_ROTATION_COUNT
世代数の指定をします。
