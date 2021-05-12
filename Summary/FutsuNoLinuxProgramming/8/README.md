# grepコマンドを作る
## 8.1 grepコマンドを作る
### ■ 基本的な正規表現
正規表現の説明についてなので省きます。
### ■ grepコマンドの概略
今回は、一文字ずつ読み込むと正規表現にマッチするかどうか判断できないため一行をバッファに読み込む必要があります。  
正規表現はlibcのAPIを使うことで扱えるようになります。

### ■ libcの正規表現API
```c
#include <sys/types.h>
#include <regex.h>

int regcomp(regex_t *reg, const char *pattern, int flags);
void regfree(regex_t *reg);
int regexec(const regex_t *reg, const char *string, size_t nmatch, regmatch_t pmatch[], int flags);
size_t regerror(int errcode, const regex_t *reg, char *msgbuf, size_t msgbuf_size);
```
