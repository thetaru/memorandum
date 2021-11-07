# memo
## 1
```
### CMD PS
driverquery
```
## 2
```
### CMD PS
systeminfo
```
## 共有
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
## ディスククリーンアップ
ディスク クリーンアップ ツール  
適用済みアップデートファイルとかいらないので定期的に削除したいよね(下コマンドのオプションはてきとー)
```
### CMD PS
cleanmgr.exe /LOWDISK
```
## 疎通確認
アクセス可能なIPアドレスを取得(arpテーブルをもとにしているっぽい)
```
### PS
Get-NetNeighbor [-InterfaceIndex <num>] [-Addressfamily IPv4] [-State Stale,Reachable]
```
StateがPermanetのものはマルチキャストアドレスやブロードキャストアドレスとなっている。  
InterfaceIndexは`Get-NetAdapter`から取得できる。

## 時刻動機
```
### CMD PS
w32tm /query /status
w32tm /query /peers
w32tm /query /source
```

## ライセンス
```
### 現在のライセンス認証の状態の確認
slmgr /dli
 
### 現在のライセンス認証の状態と猶予期間の確認
slmgr /dlv
 
### ラインセンス認証の延長処理を実行
slmgr /rearm
```

## AD
dcdiagコマンドはイベントビューアーを参照して出力することがあるので、対象ログが消えると合格することがある
```
### CMD PS
## すべてのドメコンを対象として分析
dcdiag /a
## 自サーバを対象としたドメコンの詳細分析
dcdiag /v
```
