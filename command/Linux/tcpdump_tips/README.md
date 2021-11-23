# tcpdumpでよく使うやつ
```
tcpdump [-nn] [-vvv] -i <enterface> [filter]
```
※ `i`オプションでインターフェースを指定しないと意図しないインターフェースでキャプチャすることになる

```
tcpdump -nn -vvv -i ens192 dst host 192.168.137.3 and dst port 53 and udp
```
