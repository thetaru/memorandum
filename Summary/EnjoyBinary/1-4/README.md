# 1.4 最低限のアセンブラ命令だけざっくり把握する
## ■ すべてのアセンブラ命令を覚える必要はない
よく使われるアセンブラ命令
|命令|例|意味|説明|
|:---|:---|:---|:---|
|MOV|MOV EAX,ECX|EAX = ECX|ECXの値をEAXへ格納|
|ADD|ADD EAX,ECX|EAX += ECX|EAXにECXを加算|
|SUB|SUB EAX,ECX|EAX -= ECX|EAXにECXを減算|
|INC|INC EAX|EAX++|EAXに1を加算|
|DEC|DEC EAX|EAX--|EAXに1を減算|
|LEA|LEA EAX,[ECZ+4]|EAX = ECX+4|ECX+4をEAXへ格納|
|CMP|CMP EAX,ECX|if&nbsp;(EAX == ECX)</br>&nbsp;&nbsp;&nbsp;&nbsp;ZF=1</br>else</br>&nbsp;&nbsp;&nbsp;&nbsp;ZF=0|値を比較してフラグへ反映</br>EAXとECXが同じならZF=1</br>EAXとECXが違うならZF=0|
|TEST|TEST EAX,EAX|if&nbsp;(EAX == 0)</br>&nbsp;&nbsp;&nbsp;&nbsp;ZF=1</br>else</br>&nbsp;&nbsp;&nbsp;&nbsp;ZF=0|値を0と比較してフラグへ反映</br>EAXが0ならZF=1</br>EAXが0以外ならZF=0|
|JE(JZ)|JE 04001000|if&nbsp;(ZF == 1)</br>&nbsp;&nbsp;&nbsp;&nbsp;GOTO 04001000|ZFが1なら04001000へジャンプ|
|JNE(JNZ)|JNE 04001000|if&nbsp;(ZF == 0)</br>&nbsp;&nbsp;&nbsp;&nbsp;GOTO 04001000|ZFが0なら04001000へジャンプ|
|JMP|JMP 04001000|GOTO 04001000|無条件で04001000へジャンプ|
|CALL|CALL lstrcmpW||lstrcmpWの呼び出し|
|PUSH|PUSH 00000001||スタックへ00000001を格納|
|POP|POP EAX||スタックからEAXへ値を取得|

## ■ アセンブラではどのように条件分岐が実現されているのか
アセンブラの場合、フラグを適切に管理することで実現する。  
フラグを操作するcmp、test命令とフラグの値によって処理を分岐させるジャンプ系命令で実現可能となる。  
こういった背景があるため、cpm、test命令の後にジャンプ系命令が来ることがほとんどである。  
  
例えば、wsample01a.exeでは次のように分岐されている。
```
00401019                 test    eax, eax
0040101B                 jnz     short loc_401035
```
この場合、eaxレジスタが0ならば(loc_401035へ)ジャンプせず、1ならば(loc_401035へ)ジャンプするという意味となる。

## ■ 引数はスタックに積まれる
call命令がサブルーチンの呼び出しであることは予想できるが、その戻り値がeaxレジスタに格納されるとは予想できない(と思う)。  
これはある種の決まり事であり、多くのプロセッサでは常識的に扱われるため覚えておいたほうがよい。  
  
例えば、wsample01a.exeでは次のようになっている。
```
0040100B                 push    eax
0040100C                 call    ds:lstrcmpW
```
一方、サブルーチンに渡す引数はpush命令を使ってスタックに格納される。
以上から、サブルーチンの呼び出しは次のように考えればよい。  
```c
/* C言語の関数呼び出し */
function(1,2,3);
```
```asm
;  アセンブラの関数呼び出し
push 3
push 2
push 1
call function
```
※ スタック(FIFO)なので引数の順序とは逆にpushする。
