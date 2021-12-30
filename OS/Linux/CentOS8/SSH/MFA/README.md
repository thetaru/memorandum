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
今回は、パスワード認証(チャレンジレスポンス認証)+OTP認証または鍵認証+OTP認証でログインすることを許します。(要件に応じ、設定を変更してください)
```
-  ChallengeResponseAuthentication no
+  ChallengeResponseAuthentication yes

-  PasswordAuthentication yes
+  PasswordAuthentication no

=  UsePAM yes
```
## ■ 設定ファイル /etc/pam.d/google-auth
`/etc/pam.d/google-auth`ファイルを新規作成し、以下の内容を記載します。
```
#%PAM-1.0
auth        required      pam_env.so
auth        required      pam_google_authenticator.so nullok
auth        requisite     pam_succeed_if.so uid >= 500 quiet
auth        required      pam_deny.so
```
## ■ 設定ファイル /etc/pam.d/sshd
```
#%PAM-1.0
-  auth       substack     password-auth
+  auth       substack     google-auth
   auth       include      postlogin
   account    required     pam_sepermit.so
   account    required     pam_nologin.so
   account    include      password-auth
   password   include      password-auth
   # pam_selinux.so close should be the first session rule
   session    required     pam_selinux.so close
   session    required     pam_loginuid.so
   # pam_selinux.so open should only be followed by sessions to be executed in the user context
   session    required     pam_selinux.so open env_params
   session    required     pam_namespace.so
   session    optional     pam_keyinit.so force revoke
   session    optional     pam_motd.so
   session    include      password-auth
   session    include      postlogin
```
## ■ 設定ファイル /etc/profile.d/google-authenticator.sh
```
#!/bin/sh

if [ ! -f "$HOME/.google_authenticator" ]; then
  trap 'exit' SIGINT
  echo "google-authenticator の初期設定を行います"
  /usr/bin/google-authenticator -t -d -W -u -f
  trap -- SIGINT
fi
```

## ■ REF
- https://cloudfish.hatenablog.com/entry/2020/03/12/084826
- https://dev.classmethod.jp/articles/amazon-linux-ssh-two-step-authentication/
- https://tech.buty4649.net/entry/2021/12/07/143219
- https://blog.pfs.nifcloud.com/20191002_2factor_authentication
- https://soji256.hatenablog.jp/entry/2020/05/17/150250
