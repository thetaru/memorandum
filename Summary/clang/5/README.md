# 有効範囲とプリプロセッサ
## 5.1 有効範囲
### 5.1.1 変数寿命
次のコードを書いたとします。
```c
#include <stdio.h>
void func(void);

int main(void)
{
  int hoge;
  /* 略 */
  return 0;
}

void func(void)
{
  int hoge;
}
```
### 5.1.2 static
## 5.2 プリプロセッサ
### 5.2.1 #define
### 5.2.2 #undef
### 5.2.3 引数付マクロ
### 5.2.4 #include
## 5.3 演習問題
