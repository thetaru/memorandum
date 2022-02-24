# パーティションの作成
## ■ パーティションテーブルの作成
```
parted /dev/sdX mklabel gpt
```

## パーティションの作成
一般に、スタート・エンドの指定はパーセンテージで指定すると良い。
```
# デバイス全体を一つのパーティションする例
parted /dev/sdX mkpart [primary|extended] xfs 0% 100%
```
※ 0%をサボって0と書いたりしないこと

## アライメントの確認
```
parted /dev/sdX align-check
```
