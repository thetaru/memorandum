# React 開発環境構築
## ■ インストール
### ● Node.js
#### Node.jsとnpmのインストール
```
# yum install nodejs npm
```
#### 最新のNode.jsのインストール
```
### Node.jsのバージョンを管理するライブラリnをインストール
# npm install n -g

### 安定版のNode.jsをインストール
# n stable
```
#### 古いNode.jsのアンインストール
```
### 古いパッケージのアンインストール
# yum remove nodejs npm
```
#### create-react-appのインストール
```
# npm install create-react-app -g
```

## ■ プロジェクトの作成
### ● 新規プロジェクトの作成
```
# npx create-react-app <project name>
```
### ● [Option] 新規プロジェクトの作成(Redux Toolkit)
```
# npx create-react-app <project name> --template redux
# npm install @reduxjs/toolkit
```
### ● 
