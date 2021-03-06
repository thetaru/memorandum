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
以下のことに注意してください。
- main関数の前にPlus関数を定義しなければならないことに注意してください。  
なぜこのようにしなければならないかは後で登場するプロトタイプ宣言のところで説明します。  
- 関数名はすでに使われている関数名や変数名を使わないでください。
- 関数の返り値(return)は関数宣言時に指定した型と一致させてください。  
(e.g. int型の関数なら返り値もint型でなくてはいけません)
