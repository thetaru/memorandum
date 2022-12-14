# 設定ファイルのバックアップ
以下コマンドによりバックアップが開始します。
```sh
# 変更された構成を永続ストレージと同期
vim-cmd hostsvc/firmware/sync_config

# ESXiの構成をバックアップ
vim-cmd hostsvc/firmware/backup_config
```
出力先は`/scratch/downloads`です。  
一定期間後に自動削除されるので注意してください。
