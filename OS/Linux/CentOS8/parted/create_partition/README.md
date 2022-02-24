# パーティションの作成
## ■ パーティションテーブルの作成
```
parted /dev/sdX mklabel gpt
```

## パーティションの作成
```
parted /dev/sdX mkpart [primary|extended] xfs 0% 100%
```
※ 0%をサボって0と書いたりしないこと
