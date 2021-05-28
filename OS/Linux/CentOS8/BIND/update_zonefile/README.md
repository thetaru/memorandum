# ゾーンファイルの更新
ゾーンファイルの更新時にやるべきこと。  
## 1. named or named-chroot?
chrootを使っているかどうかを確認する。
```
# systemctl status named
# systemctl status named-chroot
```
ゾーンファイルが置かれている場所がこれでわかった。
## 2. 
