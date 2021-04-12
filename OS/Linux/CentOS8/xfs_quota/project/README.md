## プロジェクトクォータ
ディレクトリに対してクォータを有効にします。
|項目|設定値|
|:---|:---|
|プロジェクト名|TestProj|
|プロジェクトID|10|
|クォータ対象ディレクトリ|/home/test|
|クォータ対象パーティション|/home|

## クォータ設定
### ■ /etc/projid
`/etc/projid`ファイルにプロジェクト名とプロジェクトIDの対応を記述します。
#### Syntax - projid
```
ProjectName:ProjectID
```
実際の場合は次のようになります。
```
# vi /etc/projid
```
```
+  TestProj:10
```
### ■ /etc/projects
`/etc/projects`ファイルにプロジェクトIDとディレクトリの対応を記述します。
#### Syntax - projects
```
ProjectID:Directory
```
実際の場合は次のようになります。
```
# vi /etc/projects
```
```
+  10:/home/test
```
※ 1つのプロジェクトIDに対して、複数のディレクトリを指定することもできます。
### ■ プロジェクト作成
#### Syntax - プロジェクト作成
```
# xfs_quota -x -c 'project -s <ProjectName>' <Partition>
```
先ほど作成したファイルをもとに、`TestProj`プロジェクトを作成します。
```
# xfs_quota -x -c 'project -s TestProj' /home
```
### ■ クォータ設定
プロジェクトに対してクォータをかける場合は、`limit -p`でサイズを指定します。
#### Syntax - クォータ設定
```
# xfs_quota -x -c 'limit -p bsoft=<Size> bhard=<Size> <ProjectName>' <Partition>
```
先ほど作成したプロジェクト`TestProj`に対してクォータをかけます。
```
# xfs_quota -x -c 'limit -p bsoft=100m bhard=100m TestProj' /home
```
### ■ クォータ解除
プロジェクトにかかったクォータの設定を解除します。  
※ クォータを無効化しただけじゃ意味がなかった...
#### Syntax - クォータ解除
```
# xfs_quota -x -c "project -C <ProjectName>" <Partition>
# xfs_quota -x -c 'limit -p bsoft=0 bhard=0 <ProjectName>' <Partition>
```
プロジェクト`TestProj`を削除し、クォータを無効化します。
```
# xfs_quota -x -c "project -C TestProj" /home
# xfs_quota -x -c 'limit -p bsoft=0 bhard=0 TestProj' /home
```
