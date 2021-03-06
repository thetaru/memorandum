# 関数
## 4.1 関数とは
関数とはいくつかの命令文をまとめたものです。
## 4.2 関数を作ってみる
#### Syntax - 関数
```c
型 関数名 ( 引数 ) { 関数の中身 }
```
実際に2つの値を入力して、その和を求める関数を作ってみます。
```c
#include <stdio.h>

int Plus(int x, int y)
{
  int result;
  result = x + y;
  return result;
}

int main(void)
{
  int hoge, piyo;
  int n;
  
  printf("2つの整数を入力してください\n");
  printf("1つ目: "); scanf("%d", &hoge);
  printf("2つ目: "); scanf("%d", &fuga);
  
  n = Plus(hoge, piyo);
  printf("足し算の結果は%dです\n", n);
  return 0;
}
```
