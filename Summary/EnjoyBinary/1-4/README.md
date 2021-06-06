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
  
wsample01a.exeでは次のようになっている。
```
00401006                 push    offset a2012    ; "2012"
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

## ■ アセンブラからC言語のソースコードをイメージできるか
wsample01b.exeのアセンブラコードも眺めてみる。
```
00401000 sub_401000      proc near               ; CODE XREF: sub_401080↓p
00401000

; cpy関数が使うローカル変数
00401000 var_2004        = byte ptr -2004h
00401000 var_1004        = byte ptr -1004h
00401000 var_4           = dword ptr -4

00401000
00401000                 push    ebp
00401001                 mov     ebp, esp
00401003                 mov     eax, 2004h
00401008                 call    __alloca_probe
0040100D                 mov     eax, ___security_cookie
00401012                 xor     eax, ebp
00401014                 mov     [ebp+var_4], eax
00401017                 push    1000h
0040101C                 lea     eax, [ebp+var_2004]
00401022                 push    eax
00401023                 push    0
00401025                 call    ds:GetModuleFileNameW
0040102B                 lea     ecx, [ebp+var_1004]
00401031                 push    ecx
00401032                 push    0
00401034                 push    0
00401036                 push    7
00401038                 push    0
0040103A                 call    ds:SHGetFolderPathW
00401040                 push    offset aWsample01bExe ; "\\wsample01b.exe"
00401045                 lea     edx, [ebp+var_1004]
0040104B                 push    edx
0040104C                 call    ds:lstrcatW
00401052                 push    0

; eaxレジスタにvar_1004領域のアドレスを格納している?
; char var_1004[2048];
; eax = var_1004;
00401054                 lea     eax, [ebp+var_1004]
0040105A                 push    eax
0040105B                 lea     ecx, [ebp+var_2004]
00401061                 push    ecx

00401062                 call    ds:CopyFileW
00401068                 mov     ecx, [ebp+var_4]
0040106B                 xor     ecx, ebp
0040106D                 xor     eax, eax
0040106F                 call    @__security_check_cookie@4 ; __security_check_cookie(x)
00401074                 mov     esp, ebp
00401076                 pop     ebp
00401077                 retn
00401077 sub_401000      endp
00401077 ; ---------------------------------------------------------------------------
00401078                 align 10h
00401080 sub_401080      proc near               ; CODE XREF: start-138↓p
00401080                 call    sub_401000
00401085                 push    0
00401087                 push    offset aMessage ; "MESSAGE"
0040108C                 push    offset aCopied  ; "Copied!"
00401091                 call    ds:GetActiveWindow
00401097                 push    eax
00401098                 call    ds:MessageBoxW
0040109E                 xor     eax, eax
004010A0                 retn    10h
004010A0 sub_401080      endp
```
sub_401080関数がメイン関数でsub_401000関数がcpy関数(メイン関数で呼び出されている)である。
