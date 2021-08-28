# clang-formatを使ったコード整形
## ■ インストール
### CentOS/RHEL
```
# yum module install llvm-toolset
# yum install cmake cmake-doc
# yum install llvm llvm-doc
```
### Ubuntu
```
# sudo apt-get install clang-format clang-tidy clang-tools clang clangd libc++-dev libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1 liblldb-dev libllvm-ocaml-dev libomp-dev libomp5 lld lldb llvm-dev llvm-runtime llvm python-clang
```

## ■ 設定
1. formatを設定したいプロジェクトのフォルダ内に.clang-formatを作成する
2. 以下のコマンドを実行するとコード整形が行われる
```
# clang-format -i -style=file XXX.c
```
※ スクリプトに組み込んでしまうとよい
