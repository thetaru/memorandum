# Arcserve Backupサーバの構築
- [ ] [Arcserve Backupのインストール](Arcserve_Backup_Install)
- [ ] [Arcserve Backupクライアント(物理)の追加](Arcserve_Backup_Client_Physical_Add)
- [ ] [Arcserve Backupクライアント(仮想)の追加](Arcserve_Backup_Client_Virtual_Add)
- [ ] [バックアップ スケジュール](Arcserve_Backup_Schedule)

## MEMO
```
# 無償版ESXiを使ったエージェントレスバックアップ
無償版なので機能制限によりエージェントレスバックアップ不可
  Current license or ESXi version prohibits execution of the requested operation.
なので検証環境では、エージェントをインストールして実施すること。
```
```
即実行の挙動
利用可能なデバイスが存在すればそれを使ってバックアップを実行する。
ない場合は利用可能なデバイスを再利用セットに置くなどする必要がある。
```
