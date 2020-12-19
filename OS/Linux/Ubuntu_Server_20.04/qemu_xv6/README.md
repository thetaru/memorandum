# QEMUでxv6を動かす
## ■ 前提条件
|項目|version|
|:---|:---|
|ESXi|6.8|
|ubuntu|20.04.1|
|qemu||

※WSL2での起動も確認済み

## ■ 手順
### パッケージのインストール
```
# apt-get install qemu-system
```
### xv6のダウンロード
```
# git clone git://github.com/mit-pdos/xv6-public.git
```
### 編集
```
# vi xv6-public/Makefile
```
```
+  QEMU = qemu-system-x86_64
```
### 実行
```
# cd xv6-public
# make qemu-nox
```
