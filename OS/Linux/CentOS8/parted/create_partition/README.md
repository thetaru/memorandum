# パーティションの作成
## ■ デバイスの確認
ディスク容量や既存のパーティション情報などを確認する。
```
parted -l /dev/sdX
parted -s /dev/sdX print
```

## ■ パーティションテーブルの作成
```
parted -s /dev/sdX mklabel gpt
```

## ■ パーティションの作成
スタート位置がわからない場合は0%を指定するとよい。(こうすると、スタート位置を自動補完する)  
エンド位置は%単位か、MB単位またはGB単位で指定する。
```
# デバイス全体を一つのパーティション(XFS)とする例
parted -s /dev/sdX mkpart [primary|extended] xfs 0% 100%
```
※ 0%をサボって0と書いたりしないこと

## ■ ファイルシステムのフォーマット
ここでは、xfsでフォーマットする。
```
# /dev/sdb1など
mkfs.xfs /dev/sdXN
```

## ■ アライメントの確認
```
parted -s /dev/sdX align-check
```
