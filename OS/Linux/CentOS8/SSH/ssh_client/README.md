# sshクライアントの設定
## ■ 鍵認証
### キーペア(公開鍵と秘密鍵)の作成
```
# ssh-keygen -t (dsa|ecdsa|ed25519|rsa|rsa1)
```
```
(snip)
Enter file in which to save the key (/home/XXX/.ssh/id_YYY):
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
(snip)
```

### 公開鍵の登録
鍵認証でSSHする対象のSSHサーバに上で作成した公開鍵の情報を渡す(`authorized_keys`に記載する)必要があります。  
コピペするのは面倒なので`ssh-copy-id`コマンドを使用します。
```
# ssh-copy-id [-n] [-p ${PORT}] -i ${PUBLIC_KEY} ${USER}@${HOST}
```
※ nオプションをつけるとドライランとなります

## ■ ポートフォワード
### ローカルフォワード
```
# ssh [-g] -L <自ホストのポート>:<対象サーバ>:<対象サーバのポート> <SSHサーバ>
```

## ■ デバッグ
