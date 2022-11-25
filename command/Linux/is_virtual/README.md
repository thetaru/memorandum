# 仮想環境かどうか調べる
## dmidecode
```sh
dmidecode -s system-product-name
```

## systemd-detect-virt
ソースみると`/sys/hypervisor/type`から取得してる
```sh
systemd-detect-virt
```
