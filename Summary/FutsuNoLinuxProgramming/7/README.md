# headコマンドを作る
## 7.1 headコマンドを作る
## ■ head.c
```c
#include <stdio.h>
#include <stdlib.h>

static void do_head(FILE *f, long nlines);

int main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr, "Usage: %s n\n", argv[0]);
        exit(1);
    }
    do_head(stdin, atol(argv[1]));
    exit(0);
}

static void do_head(FILE *f, long nlines)
{
    int c;

    if (nlines <= 0) return;
    while ((c = getc(f)) != EOF) {
        if (putchar(c) < 0) exit(1);
        if (c == '\n') {
            nlines--;
            if (nlines == 0) return;
        }
    }
}
```
## ■ main()
```c
int main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr, "Usage: %s n\n", argv[0]);
        exit(1);
    }
    do_head(stdin, atol(argv[1]));
    exit(0);
}
```
コマンドライン引数がなければエラーとします。  
※ atol()は次で紹介します。
## ■ atoi(3)、atol(3)
```c
#include <stdio.h>

int atoi(const char *str);
long atol(const char *str);
```
文字列で表現された数値を(int|long)型の数値に変換します。  
strに整数が含まれていなかったりエラーが発生した場合は0を返します。  
※ ただし、文字列の先頭が数値がであればその値を返します。
## ■ do_head()
do_head()の第1引数は読み込むストリーム、第2引数は表示する行数です。
```c
static void do_head(FILE *f, long nlines)
{
    int c;

    if (nlines <= 0) return;
    while ((c = getc(f)) != EOF) {
        if (putchar(c) < 0) exit(1);
        if (c == '\n') {
            nlines--;
            if (nlines == 0) return;
        }
    }
}
```
改行'\\n'を見つけるたびにnlinesを減らすことで、表示する行数を制限しています。(つまり、nlines行読み込むということ。)
## ■ APIの選択
headは行を扱うコマンドなのに、fgets()を使っていないのはなぜか？
1. getc()ならバッファが不要
2. fgets()は行の長さに制限あり
3. getc()でも困らない

## ■ ファイルも扱えるようにする
処理したいファイル名をコマンドライン引数に渡します。  
コマンドライン引数が2つ以上あったら2つ目以降をファイルとみなし処理します。  
引数が1つの場合は、標準出力から読み込みます。  
main()のみ変更すればいいのでmain()のみ抜粋しました。
```c
int main(int argc, char *argv[])
{
    long nlines;

    if (argc < 2) {
        fprintf(stderr, "Usage: %s n [file file...]\n", argv[0]);
        exit(1);
    }
    nlines = atol(argv[1]);
    if (argc == 2) {
        do_head(stdin, nlines);
    } else {
        int i;

        for (i = 2; i < argc; i++) {
            FILE *f;

            f = fopen(argv[i], "r");
            if (!f) {
                perror(argv[i]);
                exit(1);
            }
            do_head(f, nlines);
            fclose(f);
        }
    }
    exit(0);
}
```
ちなみに、`if (!f)`と`if (f == NULL)`は同じ意味です。
## 7.2 オプションの解析
### ■ オプションの慣習
知ってた
### ■ getopt(3)
```c
#include <unistd.h>

int getopt(int argc, char * const argv[], const char *optdecl);

extern char *optarg;
extern int optind, opterr, optopt;
```
getopt()は、オプション解析APIです。ショートオプション(`-`)のみを認識します。  
使い方は、使用例を見てください。
```c
#include <stdio.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
    int opt;
    
    while ((opt = getopt(argc, argv, "aaf:tx")) != -1) {
        switch (opt) {
        case 'a':
            /* OPTION -a */
            printf("option -a\n");
            break;
        case 'f':
            /* OPTION -f */
            printf("option -f\n");
            printf("value is %s\n", optarg);
            break;
        case '?':
            /* OPTION UNKNOWN */
            break;
        }
    }
    /* PROGRAM MAIN */
}
```
getopt()は、常にループと一緒に使います。getopt()は呼び出すごとに次のオプションを返します。  
戻り値は発見したオプションの文字です。また不正なオプションを発見した場合は'?'を返します。  
オプションがなくなった場合は-1を返します。(上のコードはオプションがなくなるまでループを続けます。)  
  
getopt()の第3引数に注目します。この引数には解析するオプションをすべて文字列として指定します。  
パラメータを取るオプションがあるときは、そのオプション文字の次にコロン(:)を付けます。  
  
例えば、パラメータを取らないオプション`-a`、`-t`、`-x`を定義するには"atx"と指定します。  
また、先ほどの3つのオプションに加えてパラメータを取るオプション`-f`を定義するには"af:tx"と指定します。  
  
次に、オプションのパラメータを得る方法を説明します。  
getopt()がパラメータをとるオプションの文字を返した場合は、グローバル変数`char *optarg`がパラメータを指しています。
|型|名前|意味|
|:---|:---|:---|
|char\*|optarg|現在処理中のオプションのパラメータ|
|int|optind|現在処理中のオプションのargvでのインデックス|
|int|optopt|現在処理中のオプション文字|
|int|opterr|trueならばエラー時にgetopt()がメッセージを表示する|

### ■ getopt_long(3)
getopt_long()は、オプション解析APIです。getopt()の機能に加えてロングオプション(`--`)も認識できます。  
```c
#define _GNU_SOURCE
#include <getopt.h>

int getopt_long(int argc, char * const argv[],
                const char *optdecl,
                const struct option *longoptdecl,
                int *longindex);
                
struct option {
    const char *name;
    int has_arg;
    int *flags;
    int val;
}

extern char *optarg;
extern int optind, opterr, optopt;
```
getopt()とは、第4引数と第5引数が違います。  
まず、第4引数が解析するロングオプションの定義です。struct optionという構造体の配列を使ってロングオプションの仕様を指示します。  
この配列の最後のstruct optionはすべてのメンバを0にする必要があります。  

|メンバ名|型|値と意味|
|:---|:---|:---|
|name|char\*|ロングオプション名|
|has_arg|int|no_argument(または0): パラメータを取らない</br>required_argument(または1): 必ずパラメータを取る</br>optional_argument(または2): パラメータを取るかもしれない|
|flags|int|NULL: このオプションを発見したときgetopt_long()はvalメンバの値を返す</br>NULL以外: このオプションを発見したときgetopt_long()は0を返し、\*flagsにvalメンバの値を代入する|
|val|int|flagsメンバで指定されたところに返す値|
  
  
flagsメンバとvalメンバの使い方は主に2つあります。  
1つ目は、flagsをNULLにしてvalにchar型の値を指定することです。  
例えば、--helpオプションを発見したときにgetopt()が'h'を返すようにしたければ、flagsをNULLにしてvalを'h'にします。(ショートオプションと同じ意味を持つロングオプションがある場合に有効です。)  
  
2つ目は、真偽値をとるオプションの値を、変数に反映させることです。  
この場合は、struct optionを次のように設定します。
```c
int opt_all = 0;

struct option[] = {
    {"--all", no_argument, &opt_all, 1},
    {0,0,0,0}
};
```
getopt_long()の第5引数がNULLでない場合は、発見したロングオプションに対応するstruct optionのインデックスをそのアドレスに返します。  
この引数は、現在処理中のオプションに対応するstruct optionを得るために使います。

### ■ オプションを扱うheadコマンド
次のオプションを定義します。
- 行数を指定`-n`
- そのロングオプション版`--lines`
- ヘルプを表示`--help`

今回もmain()のみ変更すればいいのでmain()(ともろもろ)のみ抜粋しました。
```c
#include <stdio.h>
#include <stdlib.h>

#define _GNU_SOURCE
#include <getopt.h>

static void do_head(FILE *f, long nlines);

#define DEFAULT_N_LINES 10

static struct option longopts[] = {
    {"lines", required_argument, NULL, 'n'},
    {"help", no_argument, NULL, 'h'},
    {0,0,0,0}
};

int main(int argc, char *argv[])
{
    int opt;
    long nlines = DEFAULT_N_LINES;
    
    while ((opt = getopt_long(argc, argv, "n:", longopts, NULL)) != -1) {
        switch(opt) {
        case 'n':
            nlines = atoi(optarg);
            break;
        case 'h':
            fprintf(stdout, "Usage: %s [-n LINES] [FILE ...]\n", argv[0]);
            exit(0);
        case '?':
            fprintf(stderr, "Usage: %s [-n LINES] [FILE ...]\n", argv[0]);
            exit(1);
        }
    }
    
    if (optind == argc) {
        do_head(stdin, nlines);
    } else {
        int i;
        
        for (i = optind; i < argc; i++) {
            FILE *f;
            
            f = fopen(argv[i], "r");
            if (!f) {
                perror(argv[i]);
                exit(1);
            }
            do_head(f, nlines);
            fclose(f);
        }
    }
    exit(0);
}
```
### ■ 7.4 練習問題
#### 1
フラグ管理するだけ
```c
#include <stdio.h>
#include <stdlib.h>

#define _GNU_SOURCE
#include <getopt.h>

#define N_FLAG 1
#define T_FLAG 2

static struct option longopts[] = {
    {"tab", no_argument, NULL, 't'},
    {"new", no_argument, NULL, 'n'},
    {0,0,0,0}
};

int main(int argc, char *argv[])
{
    int opt;
    unsigned char flag = 0;
    while ((opt = getopt_long(argc, argv, "nt", longopts, NULL)) != -1) {
        switch(opt) {
        case 'n':
            flag |= N_FLAG;
            break;
        case 't':
            flag |= T_FLAG;
            break;
        case '?':
            fprintf(stderr, "Usage: %s [-n] [-t]\n", argv[0]);
            exit(1);
        }
    }

    int i;

    for (i = optind; i < argc; i++) {
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
                if (flag & T_FLAG) {
                    if (fputs("\\t", stdout) == EOF) exit(1);
                } else {
                    if (fputs("\t", stdout) == EOF) exit(1);
                }
                break;
            case '\n':
                if (flag & N_FLAG) {
                    if (fputs("$\n", stdout) == EOF) exit(1);
                } else {
                    if (fputs("\n", stdout) == EOF) exit(1);
                }
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
