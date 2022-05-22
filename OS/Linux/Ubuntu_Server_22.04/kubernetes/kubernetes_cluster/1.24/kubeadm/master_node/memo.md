# memo
## 調べる優先順位
次の３つが最優先かな。(上に乗るサービスによって変える必要がありそうだから)
- CRI
- CNI
- CSI

## ハマった
- マスターノードのcontainerdとkubeletでcgroup driverが一致しないと6443ポートがバインドされない。

## 対応
- firewallやAppArmor下で動かせるようにしたいかな。


## エラー
ワーカーノードのcontainerdの`systemd_cgroup = true`にしたらkubeletが動作しなくなった。(falseに戻せば起動する。)
```
failed to run Kubelet: unable to determine runtime API version: rpc error: code = Unavailable desc = connection error: desc = "transport: Error while dialing dial unix: missing address
```
