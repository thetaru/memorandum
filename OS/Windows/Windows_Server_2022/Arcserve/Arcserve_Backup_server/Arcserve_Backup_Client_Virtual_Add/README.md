# Arcserve Backupクライアント(仮想)の追加
ここでは、VMware製品のESXiやvCenter上に構築された仮想マシン(以下、VMと呼ぶ)のバックアップ(イメージバックアップ)を想定する。  
そのため、各VMに`VMware Tools`をインストールする必要がある。  
※ 補足: Nested ESXiの環境で実施してみたが、クライアントの追加でつまづいた

## ■ エージェントレスバックアップ
ESXiやvCenter上の仮想マシンの場合、Arcserve BackupがESXiやvCenterと連携することでVMにエージェントをインストールすることなくバックアップすることが可能となる。

## ■ エージェントバックアップ
