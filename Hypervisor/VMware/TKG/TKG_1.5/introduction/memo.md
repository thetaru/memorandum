# memo
## ■ デプロイ時の注意事項
- TKG NWには、DHCP必須
- ディスク不足、メモリ不足でコケる -> コンテナのボリューム肥大化の場合はdocker system prune (|--volumes|--all)で削除
- docker cgroup1にしないとコケる
- selinux/apparmorでコケる
- Timeoutでコケる(default:30min) -> CLIで実行しオプションからタイムアウト値を伸ばす
