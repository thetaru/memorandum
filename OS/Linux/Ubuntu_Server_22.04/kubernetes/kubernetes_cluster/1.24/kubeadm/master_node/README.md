# マスターノードの構築
## ■ 事前準備
Ubuntu Serverの構築は済んでいるとする。
### スワップ領域の無効化
kubeletが正常動作するために、swapをオフにする必要がある。  
そのため、OSインストール時に必要以上にスワップ領域を確保する必要はない。
```sh
# スワップ領域がsystemd管理下にある場合
systemctl --type swap
systemctl mask XXX.swap
```
※ systemd管理ではない場合、`swapoff -a`したあと、fstabからswapの記述をコメントアウトする
