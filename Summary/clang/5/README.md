# 有効範囲とプリプロセッサ
## 5.1 有効範囲
### 5.1.1 変数寿命
スコープについての解説。こういうのは図とともに理解するほうがいいとおもう。  
### 5.1.2 static
`staic`を付けて宣言された変数はプログラム開始時に変数が作られプログラム終了時に消滅します。  
`staic`のことを**記憶域クラス指定子**といいます。  
実際に`static`を使ったプログラムを書いてみます。
```c
#include <stdio.h>

void func(void);

int main(void)
{
  func();
  func();
  func();
  return 0;
}

void func(void)
{
  static int hoge = 10;
  hoge++;
  printf("hoge = %d\n", hoge);
}
```
func関数を通るたびに10が初期化されていないことがわかります。(プログラムが終了していないためhogeの値を引き継いでいます。)  
static変数の初期化はプログラム開始前の一度だけ行われることがわかりました。
## 5.2 プリプロセッサ
### 5.2.1 #define
`#define`とは文字列に値を置換するものです。
#### Syntax - #define
```c
#define 文字列A 文字列B
``` 
実際に`#define`を使ったプログラムを書いてみます。
```c
#include <stdio.h>
#define NUMBER 10

int main(void)
{
  printf("%d\n", NUMBER);
  return 0;
}
```
`#define`を使って定義した文字列に名前をつけるときはすべて大文字にしましょう。(定数として使う場合がほとんどなので)  
`#define`で定義する際にセミコロンを付けないように注意します。(セミコロンも含めて置換されてしまうため)
### 5.2.2 #undef
`#undef`とは定義済みのマクロを無効化する際に使います。
```c
#undef 文字列A
```
実際に`#undef`を使ったプログラムを書いてみます。
```c
#include <stdio.h>
#define NUMBER 10
#undef NUMBER
#define NUMBER 11

int main(void)
{
  printf("%d\n", NUMBER);
  return 0;
}
```
上のプログラムで既に定義済みのマクロを無効にして新たに定義しています。
### 5.2.3 引数付マクロ
### 5.2.4 #include
## 5.3 演習問題
