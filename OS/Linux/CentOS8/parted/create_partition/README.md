# パーティションの作成
## ■ デバイスの確認
ディスク容量や既存のパーティション情報などを確認する。
```sh
parted -l /dev/sdX
parted -s /dev/sdX print
```

## ■ パーティションテーブルの作成
```sh
parted -s /dev/sdX mklabel gpt
```

## ■ パーティションの作成
スタート位置がわからない場合は0%を指定するとよい。(こうすると、スタート位置を自動補完する)  
エンド位置は%単位か、MB単位またはGB単位で指定する。
```sh
# デバイス全体を一つのパーティション(XFS)とする例
parted -s /dev/sdX mkpart [primary|extended] xfs 0% 100%
```
※ 0%をサボって0と書いたりしないこと

## ■ ファイルシステムのフォーマット
ここでは、xfsでフォーマットする。
```sh
# /dev/sdXNにはパーティションを指定する
mkfs.xfs /dev/sdXN
```

## ■ アライメントの確認
```sh
# Nにはパーティション番号を指定する
parted -s /dev/sdX align-check optimal N
```
