# ストリームにかかわるライブラリ関数
## 6.1 stdio
### ■ バッファリング
読み込み側を例にして説明します。  
read()は、バイト単位の入力しかできないので、stdioは一時的にデータを保存する場所(バッファ)を用意します。  
そしてread()を使ってバッファに入力し、プログラムから1バイトほしいと言われたらバッファから1バイト取って返します。  
このようにバッファ経由でデータをやりとりすることを、バッファリングといいます。
### ■ バッファリングモード
書き込み側の場合も読み込みと同様にバッファが必要になります。  
バイト単位や行単位の出力を受け、バッファがいっぱいになったらwrite()で書き出します。  
ただし、例外があります。  
1. バッファがいっぱいになったタイミングがわからないこと
> 特にストリームが端末とつながっている場合バッファがいついっぱいになるのかわからないので、改行('\n')が書き込まれた時点でwrite()します。
2. stdioストリームがアンバッファードモードになっていること
> アンバッファードモードのstdioストリームに書き込むと、バッファリングせずにwrite()されます。
3. stdioストリームが標準エラー出力に対応するストリームstderrになっていること
> stderrは、例外的に最初からアンバッファードモードになっています。エラーメッセージをユーザにすぐ見せたいためです。

### ■ FILE型
システムコールでは、ストリームを指すのにファイルディスクリプタ(整数)を使っていました。  
一方、stdioではFILE型へのポインタを使います。  
※ FILE型は、typedefで定義された型で、ファイルディスクリプタとstdioバッファの内部情報が入っています。

### ■ stdioでの標準入出力
システムコールでは、標準入力や標準出力するために、それぞれに対応するファイルディスクリプタ(やそのマクロ)が提供されていました。  
それに対応する形でstdioにも標準入力や標準出力を表現するFILE\*型の変数が用意されています。
|ファイルディスクリプタ|マクロ名|stdioでの変数名|意味|
|:---|:---|:---|:---|
|0|STDIN_FILENO|stdin|標準入力|
|1|STDOUT_FILENO|stdout|標準出力|
|2|STDERR_FILENO|stderr|標準エラー出力|

### ■ fopen(3)
fopen()は、stdioにおいてシステムコールのopen()に対応するAPIです。
### Syntax - fopen
```c
#include <stdio.h>

FILE *fopen(const char *path, const char *mode);
```
fopen()は、ファイルをパスで指定し、そのファイルにつながるストリームをつくり、それを管理するFILE型へのポインタを返します。  
何らかの理由で失敗した場合はNULLを返し、原因を表す定数をerrnoにセットします。  
第2引数modeにはストリームの性質を指定します。
|値|対応するopen(2)のmode|意味|
|:---|:---|:---|
|"r"|O_RDONLY|読み込み専用</br>ファイルはあらかじめ存在しなくてはならない|
|"w"|O_WRONLY\|O_CREAT\|O_TRUNC|書き込み専用</br>ファイルが存在しなければ作成し、存在する場合はサイズを0にして書き込む|
|"a"|O_WRONLY\|O_CREAT\|O_APPEND|追加書き込み専用</br>ファイルが存在しなければ作成し、存在する場合はファイルの末尾から書き込む|
|"r+"|O_RDWR|読み書き両用</br>ファイルはあらかじめ存在しなくてはならない|
|"w+"|O_RDWR\|O_CREAT\|O_TRUNC|読み書き両用</br>ファイルが存在しなければ作成し、存在する場合はサイズを0にして書き込む|
|"a+"|O_RDWR\|O_CREAT\|O_APPEND|読み書き両用</br>ファイルが存在しなければ作成し、存在する場合はファイルの末尾から書き込む|

### ■ fclose(3)
fclose()は、stdioにおいてシステムコールのclose()に対応するAPIです。
### Syntax - fclose
```c
#include <stdio.h>

int fclose(FILE *stream);
```
fclose()は、ストリームを閉じます。fopen()で開いたファイルはfclose()で閉じなければいけません。  
fclose()は成功すれば0を返します。失敗すると定数EOFを返し、失敗の原因を表す定数をerrnoにセットします。  
※ EOFはstdio.hで定義されるマクロで、通常は-1です。
## 6.2 バイト単位の入出力
バイト単位の入出力APIで代表的なのはfgetc()とfputc()です。
### ■ fgetc(3)、fputc(3)
```c
#include <stdio.h>

int fgetc(FILE *stream);
int fputc(int c, FILE *stream);
```
fgetc()は、引数のstreamから1バイト読み込んで返し、ストリームが終了した場合はEOFを返します。  
  
fputc()は、引数のstreamにcバイトを書き込みます。  
> fgetc()で取得したバイトをfputc()にそのまま渡すことができるようになっています。
### ■ getc(3)、putc(3)
fgetc()とfputc()のマクロとして定義されます。
```c
#include <stdio.h>

int getc(FILE *stream);
int putc(int c, FILE *stream);
```
機能に違いはありません。
### ■ getchar(3)、putchar(3)
入力元・出力先が固定(それぞれ、標準入力と標準出力)されているバイト単位の入出力APIです。
```c
#include <stdio.h>

int getchar(void);
int putchar(int c);
```
getchar()は、getc(stdin)と同じ意味です。  
putchar()は、putc(c, stdout)と同じ意味です。
### ■ ungetc(3)
バイト単位で値をバッファに戻すAPIとしてungetc()があります。
```c
#include <stdio.h>

int ungetc(int c, FILE *stream);
```
ungetc()は、バイトcをstreamのバッファに戻します。(つまり、次にfgetc()などでstreamから読み込むとcが返ります。)  
※ ただし、1つのstreamに対して連続してungetc()することはできません。
## 6.3 stdio版catコマンドを作る
1バイト入出力関すを使ってcatコマンドを書き直します。
```c
### FileName: cat2.c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    int i;
    
    for (i = 1; i < argc; i++) {
        FILE *f;
        int c;
        
        f = fopen(argv[i], "r");
        if (!f) {
            perror(argv[i]);
            exit(1);
        }
        while ((c = fgetc(f)) != EOF) {
            if (putchar(c) < 0) exit(1);
        }
        fclose(f);
    }
    exit(0);
}
```
説明するところはwhile文のところくらいです。
```c
        while ((c = fgetc(f)) != EOF) {
            if (putchar(c) < 0) exit(1);
        }
```
やっていることは、ストリームが終了するまで(ファイル終端にいくまで)読み込んでから標準出力するループをしているだけです。  
標準出力が失敗したらプログラムを終了するようにしています。
## 6.4 文字列の入出力
### ■ Linuxにおける行
行を表現するには、行の終端(改行コード)を定義する必要があります。一般の場合は'\\n'などです。  
特殊な例として、ファイルの最後やストリームからの入力の末尾に'\\n'がない場合も、そこまでを1行とみなします。
### ■ fgets(3)
行単位の入力APIとしてfgets()があります。
```c
#include <stdio.h>

char *fgets(char *buf, int size, FILE *stream);
```
fgets()は、ストリームstreamから1行読み込んで第1引数のバッファbufに格納します。  
ただし、fgets()はどんな場合でも最大size-1バイトまでしか読みません。  
※ size-1となるのは、NULL文字'\\0'を行末に書き込むからです。  
  
fgets()は、正常に1行読み込むか、size-1バイト読んだ場合にbufを返します。  
1文字も読まずにEOFに当たった場合にNULLを返します。  
  
fgets()には問題があり、1行読み込んで止まったのか、バッファがいっぱいまで書き込んで止まったのかを区別できません。  
※ そのために自前でgetc()を使って読み込む必要があります。
### ■ fputs(3)
出力APIとしてfputs()があります。  
※ 行単位での出力とは限らないことに注意してください。
```c
#include <stdio.h>

int fputs(const char *buf, FILE *stream);
```
fputs()は、文字列bufをstreamに書き込みます。  
  
fputs()は、正常に出力できたときは0以上の整数を返します。  
ストリームにすべてのバイト列を書き終えたか、なにか問題が起きるとEOFを返します。  
問題が起きた場合は、原因を表す定数がerrnoにセットされます。  
ストリームが終了した場合と区別するために、次のコードのようにあらかじめerronoを0にする必要があります。
```c
#include <stdio.h>

{
    errno = 0;
    if (fputs(buf, f) == EOF) {
        if (errno != 0) {
            /* ERROR OCCURED */
        }
    }
}
```
### ■ puts(3)
fputs()とほぼ同じ機能ですが、挙動がすこし違います。
```c
#include <stdio.h>

int puts(const char *buf);
```
puts()は、文字列bufを標準出力に出力し、そのあと改行'\\n'を出力します。  
fputs()との違いは、出力先が標準出力に固定されていることと、改行'\\n'が追加されることです。  
※ fgets()で入力した文字列には'\\n'がついているので、fgets()で読み込んだ行をそのままputs()に渡すと、'\\n'が1つ余分に付いてしまいます。  
### ■ printf(3)、fprintf(3)
```c
#include <stdio.h>

int printf(const char *fmt, ...);
int fprintf(FILE *stream, const char *fmt, ...);
```
第1引数fmtは書式文字列です。(型指定子の説明は省きます。)  
出力先は、printf()だと標準出力、fprintf()だと引数のstreamです。
### ■ scanf(3)
つかわないでください。

## 6.5 固定長の入出力
### ■ fread(3)
```c
#include <stdio.h>

size_t fread(void *buf, size_t size, size_t nmemb, FILE *stream);
```
streamから (size \* nmemb)バイト読み込み、bufに格納します。  
成功した場合はnmembを返し、失敗したか(size \* nmemb)バイト読む前にEOFに到達した場合はnmembより小さい値を返します。  
fread()は'\0'終端を期待しないバイト例を扱うAPIなので、バッファ末尾に'\0'を書き込みません。
### ■ fwrite(3)
```c
#include <stdio.h>

size_t fwrite(const void *buf, size_t size, size_t nmemb, FILE *stream);
```
(size \* nmemb)バイト分のバイト列をbufからstreamに書き込みます。  
成功した場合はnmembを返し、失敗した場合はnmembより小さい値を返し、原因を表す定数をerronoにセットします。
## 6.6 ファイルオフセットの操作
### ■ fseek(3)、fseeko(3)
```c
#include <stdio.h>

int fseek(FILE *stream, log offset, int whence);
int fseeko(FILE *stream, off_t offset, int whence);
```
lseek()システムコールに対応するのがfseek()とfseeko()です。  
streamのファイルオフセットを、whenceとoffsetで示される位置に移動します。  
※ whenceで指定できる値はlseek(2)と同様です。  
  
### ■ ftell(3)、ftello(3)
```c
#include <stdio.h>

log ftell(FILE *stream);
off_t ftello(FILE *stream);
```
ftell()は、streamのファイルオフセットの値を返します。  

### ■ rewind(3)
```c
#include <stdio.h>

void rewind(FILE *stream);
```
rewind()は、streamのファイルオフセットをファイルの先頭に戻します。
## 6.7 ファイルディスクリプタとFILE型
FILEとは、生のストリームにバッファ機能を追加するラッパーのことでした。  
つまり、FILEはファイルディスクリプタのラッパーです。
### ■ fileno(3)
```c
#include <stdio.h>

int fileno(FILE *stream);
```
streamがラップしているファイルディスクリプタを返します。
### ■ fdopen(3)
```c
#include <stdio.h>

FILE *fdopen(int fd, const char *mode);
```
ファイルディスクリプタfdをラップするFILE型の値を新しく作成してそのポインタを返します。  
失敗したらNULLを返します。  
第2引数modeの意味は、fopen()の第2引数と同じです。
## 6.8 バッファリングの操作
### ■ fflush(3)
```c
#include <stdio.h>

int fflush(FILE *stream);
```
fflush()は、streamがバッファリングしている内容を即座にwrite()させます。  
成功した場合は0を返し、失敗した場合はEOFを返して失敗の原因を表す定数をerrnoにセットします。  
  
fflush()は、改行せずに文字列を端末に出力したいときに使います。
### ■ setvbuf(3)
setvbuf()というAPIを使うと、自前で用意したバッファをstdioに使わせることができます。  
また、バッファリングモードを変更することもできます。

## 6.9 EOFとエラー
### ■ feof(3)
```c
#include <stdio.h>

int feof(FILE *stream);
```
feof()は、直前の読み取り操作でstreamがEOFに達していたらtrueを返します。  
※ 使ってはいけません。
### ■ ferror(3)
```c
#include <stdio.h>

int ferror(FILE *stream);
```
ferror()は、直前の入出力操作でエラーが起きたらtrueを返します。
### ■ clearerr(3)
```c
#include <stdio.h>

void clearerr(FILE *stream);
```
clearerr()は、streamのエラーフラグとEOFフラグをクリアします。  
使いどころとしては、`tail -f`のようなリアルタイムに表示させる必要がある場合でしょうか。  
## 6.11 練習問題
### 1
```c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    int i;

    for (i = 1; i < argc; i++) {
        FILE *f;
        int c;

        f = fopen(argv[i], "r");
        if (!f) {
            perror(argv[i]);
            exit(1);
        }
        while ((c = fgetc(f)) != EOF) {
            switch (c) {
            case '\t':
                if (fputs("\\t", stdout) == EOF) exit(1);
                break;
            case '\n':
                if (fputs("$\n", stdout) == EOF) exit(1);
                break;
            default:
                if (putchar(c) < 0) exit(1);
            }
        }
        fclose(f);
    }
    exit(0);
}
```
### 2
```c
```
