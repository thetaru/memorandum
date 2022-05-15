# DHCPサーバの構築
## ■ インストール
```
# yum install dhcp-server
```

## ■ バージョンの確認
```
# dhcpd --version
```

## ■ サービスの起動
```
# systemctl enable --now dhcpd.service
```

## ■ 設定ファイル /etc/dhcp/dhcpd.conf

## ■ 設定ファイル /etc/systemd/system/dhcpd.service
ユニットファイル`/usr/lib/systemd/system/dhcpd.service`を`/etc/systemd/system`にコピーする。  
DHCPサーバが複数のNICを持つ場合、DHCPを機能させるインターフェースを指定する。
```
-  ExecStart=/usr/sbin/dhcpd -f -cf /etc/dhcp/dhcpd.conf -user dhcpd -group dhcpd --no-pid $DHCPDARGS
+  ExecStart=/usr/sbin/dhcpd -f -cf /etc/dhcp/dhcpd.conf -user dhcpd -group dhcpd --no-pid <interface>
```
