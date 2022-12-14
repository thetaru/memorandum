# 設定ファイルのバックアップ・リストア
## ■ バックアップ
以下コマンドによりバックアップを実行します。
```sh
# 1. 変更された構成を永続ストレージと同期
vim-cmd hostsvc/firmware/sync_config

# 2. ESXiの構成をバックアップ
vim-cmd hostsvc/firmware/backup_config
```
上記コマンドの実行後、出力されるURLからバックアップファイルをWebブラウザ経由でダウンロードすることができます。  
SCPなどで取得する場合は、バックアップファイルが`/scratch/downloads`下に生成されるので、ここから採取します。  
バックアップファイルは、一定期間後に自動削除されることに注意してください。

## ■ リストア
以下コマンドによりリストアを実行します。  
※ 以下、バックアップファイルを`/tmp`に配置した想定で実施します。
```sh
# 1. バックアップファイル`configBundle-<hostname>.tgz`をリネーム
mv configBundle-<hostname>.tgz configBundle.tgz

# 2. ESXiをメンテナンスモードに移行
vim-cmd hostsvc/maintenance_mode_enter

# 3. ESXiの構成をリストア
vim-cmd hostsvc/firmware/restore_config /tmp/configBundle.tgz
```
