
## ■ パッケージリスト自動更新の設定
デフォルトでは、自動でパッケージリストを更新し、パッケージのアップグレードを行います。  
一連の処理は`/etc/apt/apt.conf.d/`配下のファイルに沿って実行されます。(実行順序は名前の昇順)  
  
自動パッケージリスト更新と自動パッケージアップグレードを無効にします。
```
$ sudo vim /etc/apt/apt.conf.d/20auto-upgrades
```
```
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
```
アップグレード対象となるパッケージをすべてコメントアウトし、アップグレードから除外するパッケージ(以下ではlinux-から始まるパッケージ名)を指定します。
```
$ sudo vim /etc/apt/apt.conf.d/50unattended-upgrades
```
```
Unattended-Upgrade::Allowed-Origins {
//    "${distro_id}:${distro_codename}";
//    "${distro_id}:${distro_codename}-security";
//    "${distro_id}ESMApps:${distro_codename}-apps_security";
//    "${distro_id}ESM:${distro_codename}-infra-security";
//    "${distro_id}:${distro_codename}-updates";
//    "${distro_id}:${distro_codename}-proposed";
//    "${distro_id}:${distro_codename}-backports";
};

Unattended-Upgrade::Package-Blacklist {
    "linux-";
};
```

## ■ パッケージアップデート制限の設定
カーネルなどのパッケージがaptコマンドによってアップデートされないようにします。
```
# linux-から始まる名前のパッケージをホールド対象とする
$ sudo apt-mark hold $(dpkg-query -Wf '${Package}\n' | grep "^linux-")
```
ホールドしているパッケージ名を確認します。
```
$ apt-mark showhold
```
※ ホールド対象から除外するパッケージがある場合は、`apt-mark unhold`コマンドを使用する
