# 1.1 C言語から機械語へ
CPUは機械語の列だけを解釈できます。  
例えば、以下のC言語のソースコード
```c
void func(void) {
  int val = 0;
  val++;
}
```
を機械語に変換すると
```
55 89 e5 83 ec 10 c7 45 fc 00 00 00 00 ff 45 fc c9 c3
```
(16進数表示ですが)0と1の列に変換されたことがわかります。  
CPUはこのような0と1だけからなる機械語しか解釈・実行できません。  

# 1.2 機械語とアセンブリ言語
機械語は人間にとってわかりずらいので、比較的読みやすいアセンブリ言語が作られました。  
上で挙げたソースコードをアセンブラ言語に変換し機械語と対応させたものを示します。
```asm
push ebp                    ; 55
mov ebp, esp                ; 89 e5
sub esp, byte +0x10         ; 83 ec 10
mov dword [ebp-0x4], 0x0    ; c7 45 fc 00 00 00 00
int dword [ebp-0x4]         ; ff 45 fc
leave                       ; c9
ret                         ; c3
```
機械語とアセンブリ言語は(例外を除き)一対一に対応しますが、機械語とC言語に一対一に対応しません。  
※ C言語にはシュガーシンタックスがあるので当たり前ですよね？  
  
# 1.3 機械語に飛び込む
機械語をアセンブリ言語に変換することを逆アセンブルといいます。  
まず、C言語ファイルcasm-c-sample.cを32bitバイナリcasm-c-sample.binにコンパイルします。
```
# gcc -Wl,--entry=func,--oformat=binary -nostdlib -fno-asynchronous-unwind-tables -m32 -o casm-c-sample.bin casm-c-sample.c
```
次に、32bitバイナリcasm-c-sample.binを逆アセンブルし、アセンブリ言語表示します。
```
# 
```
