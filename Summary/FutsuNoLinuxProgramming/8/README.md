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

#### regcomp
正規表現のコンパイルを行います。

|引数|意味|
|:---|:---|
|reg|コンパイルされた正規表現へのポインタ|
|pattern|正規表現を指定する|
|flags|以下のフラグのORを指定する|

|flags|意味|
|:---|:---|
|REG_EXTENDED|POSIX拡張正規表現を使用する|
|REG_ICASE|大文字と小文字を区別しない|
|REG_NOSUB||
|REG_NEWLINE|改行文字の扱いを変更する|

|戻り値|意味|
|:---|:---|
|成功|読み込んだバイト数|
|失敗|-1|
