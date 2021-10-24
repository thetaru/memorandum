# memo
```
### CMD PS
driverquery
```
```
### CMD PS
systeminfo
```
```
# これだけで一つ記事かける
### PS
### ディレクトリ掘る
New-Item -Path "C:\test" -ItemType Directory
### 共有出す(オプションでアクセス制限もかけられる)
New-SmbShare -Name shared -Path "C:\test" -Description "上から来るぞ！気をつけろぉ！"
### 共有情報の確認
Get-SmbShare -Name shared | Format-List -Property *
### 共有解除
Remove-SmbShare -Name shared
```
ディスク クリーンアップ ツール  
適用済みアップデートファイルとかいらないので定期的に削除したいよね(下コマンドのオプションはてきとー)
```
### CMD PS
cleanmgr.exe /LOWDISK
```
アクセス可能なIPアドレスを取得
```
### PS
Get-NetNeighbor [-InterfaceIndex <num>] [-Addressfamily IPv4] [-State Stale,Reachable]
```
