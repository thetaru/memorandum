# 二段階認証sshサーバの構築
Google Authenticatorを使ってOTP認証をします。  
必要に応じて、スマホなどにGoogle Authenticatorアプリ等のOTP対応のアプリをインストールしてください。
## ■ 前提条件
すでにSSHサーバとして動作していることを前提とします。

## ■ インストール
EPELレポジトリをインストールします。
```
# yum install epel-release
```
Google Authenticator PAM moduleをインストールします。
```
# yum install google-authenticator qrencode
```

## ■ 設定ファイル /etc/ssh/sshd_config
## ■ 設定ファイル /etc/pam.d/google-auth
## ■ 設定ファイル /etc/pam.d/sshd
## ■ 設定ファイル /etc/profile.d/google-authenticator.sh

## ■ REF
- https://cloudfish.hatenablog.com/entry/2020/03/12/084826
- https://dev.classmethod.jp/articles/amazon-linux-ssh-two-step-authentication/
- https://tech.buty4649.net/entry/2021/12/07/143219
- https://blog.pfs.nifcloud.com/20191002_2factor_authentication
- https://soji256.hatenablog.jp/entry/2020/05/17/150250
