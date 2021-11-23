# tcpdumpでよく使うやつ
`i`オプションでインターフェースを指定しないと意図しないインターフェースでキャプチャすることになるためほぼ必須です。
```
tcpdump [-nn] [-vvv] [] -i <enterface> [filter]
```

## 例
送信先ホストが192.168.137.1 かつ 送信先ポートが80/tcp,udp の条件を満たすパケットをキャプチャ
```
tcpdump -nn -vvv -i ens192 dst host 192.168.137.1 and dst port 80
```
送信先ホストが192.168.137.3 かつ 送信先ポートが53/udp の条件を満たすパケットをキャプチャ
```
tcpdump -nn -vvv -i ens192 dst host 192.168.137.3 and dst port 53 and udp
```
送信先ホストが192.168.137.3 かつ 送信先ポートが53/udp の条件を満たすパケットをキャプチャし、ペイロード情報を表示
```
tcpdump -X -nn -vvv -i ens192 dst host 192.168.137.3 and dst port 53 and udp
```
