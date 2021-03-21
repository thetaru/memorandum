# Linuxプログラミングを始めよう
## 1.1 本書の構成
Linuxの構成概念は次の３つです。
- ファイルシステム
- プロセス
- ストリーム

Linuxはこの３つの概念によって成立しているので、この3つの概念を理解していくことを目標にします。
## 1.2 プログラミング環境の準備
(既にインストール済みの場合は不要です。)gccをインストールします。
```
$ sudo yum install gcc
```
gccのバージョンを確認します。
```
$ gcc --version
```
## 1.3 gccを使ったビルド(1)
いつもどおりHello Worldを出力するプログラムを作ります。
```c
/* File Name: hello.c */
#include <stdio.h>

int main(int argc, char* argv[])
{
  printf("Hello World\n");
  return 0;
}
```
このファイルをビルドします。
```
$ gcc hello.c -o hello.o
```
出力されたプログラムを実行します。
```
$ ./hello.o
```
実行するとHello Worldを出力します。
