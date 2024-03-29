# sshクライアントの設定
## ■ 鍵認証
### キーペア(公開鍵と秘密鍵)の作成
説明するときは、`公開鍵を鍵穴・秘密鍵を鍵`と言うのがよさそう。
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
# ssh-copy-id [-n] [-p ${SSH_SERVER_PORT}] -i ${PUBLIC_KEY} ${USER}@${SSH_SERVER}
```
※ nオプションをつけるとドライランとなります

## ■ ポートフォワード
### ローカルフォワード
#### 文法
```
# ssh [-g] -L ${HOST_PORT}:${TARGET_HOST}:${TARGET_PORT} ${USER}@${SSH_SERVER}
```
※ gオプションをつけると

#### 例
SSHサーバ(192.168.0.1)から80番ポートを開放しているサーバ(192.168.0.10)にアクセスできることを前提とします。  
以下のコマンドにより、ローカル(127.0.0.1)のポート10080とリモートサーバ(192.168.0.10)のポート80を紐付けることができます。
```
# ssh -L 10080:192.168.0.10:80 192.168.0.1
```
