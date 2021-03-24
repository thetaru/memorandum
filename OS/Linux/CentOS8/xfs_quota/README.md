# xfsクォータ
## ■ プロジェクトクォータ
|項目|設定値|
|:---|:---|
|プロジェクト名|TestProj|
|プロジェクトID|10|
|クォータ対象ディレクトリ|/quota/test|
|クォータ対象パーティション|/quota|

## クォータ設定
## クォータ解除
```
# xfs_quota -x -c "project -C TestProj" /quota
# xfs_quota -x -c 'limit -p bsoft=0 bhard=0 TestProj' /quota
```
