# tcpdumpでよく使うやつ
`i`オプションでインターフェースを指定しないと意図しないインターフェースでキャプチャすることになるためほぼ必須です。  
ちなみにfirewall(L3-4)よりもtcpdump(L2)のほうがチェックがはやいので、firewallで弾かれるべきパケットが弾かれていないと勘違いしないようにしましょう。
```
tcpdump [-nn] [-vvv] [-X] [-U] [-w <file>] -i <enterface> [filter]
```
filterには色々な指定方法があり、検索すれば出てくるのでここでは特に触れないことにします。

## 例
送信先ホストが192.168.137.1 かつ 送信先ポートが80/tcp,udp の条件を満たすパケットをキャプチャ
```sh
tcpdump -nn -vvv -i ens192 dst host 192.168.137.1 and dst port 80
```
送信先ホストが192.168.137.3 かつ 送信先ポートが53/udp の条件を満たすパケットをキャプチャ
```sh
tcpdump -nn -vvv -i ens192 dst host 192.168.137.3 and dst port 53 and udp
```
送信先ホストが192.168.137.3 かつ 送信先ポートが53/udp の条件を満たすパケットをキャプチャし、ペイロード情報を表示
```sh
tcpdump -nn -vvv -X -i ens192 dst host 192.168.137.3 and dst port 53 and udp
```
任意のインターフェースから80/tcpの条件を満たすパケットをキャプチャし、ファイル(`/tmp/tcpdump.log`)に出力  
ただし、`-U`オプションによりバッファリングせずにファイルへ出力するためトラフィックの多いサーバで利用するときは注意
```sh
tcpdump -i any -U -w "/tmp/tcpdump.log" tcp port 80
```
