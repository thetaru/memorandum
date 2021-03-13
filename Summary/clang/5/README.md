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
