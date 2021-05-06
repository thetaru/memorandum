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
#include <unistd.h>

int main(int argc, char *argv[])
{
    int opt;
    
    while ((opt = getopt(argc, argv, "aaf:tx")) != -1) {
        switch (opt) {
        case 'a':
            /* OPTION -a */
            printf("option -a\n");
            break
        case 'f':
            /* OPTION -f */
            printf("option -f\n");
            break
        case '?':
            /* OPTION UNKNOWN */
            break
        }
    }
    /* PROGRAM MAIN */
}
```
