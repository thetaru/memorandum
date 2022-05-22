# memo
## 調べる優先順位
次の３つが最優先かな。(上に乗るサービスによって変える必要がありそうだから)
- CRI
- CNI
- CSI

## ハマった
- マスターノードのcontainerdとkubeletでcgroup driverが一致しないと6443ポートがバインドされない。
