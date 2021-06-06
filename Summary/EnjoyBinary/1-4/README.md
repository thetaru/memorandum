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
|JE(JZ)|JE 04001000|if&nbsp;(ZF == 1)</br>&nbsp;&nbsp;&nbsp;&nbsp;GOTO 04001000||
|JNE(JNZ)|JNE 04001000|if&nbsp;(ZF == 0)</br>&nbsp;&nbsp;&nbsp;&nbsp;GOTO 04001000||
|JMP|JMP 04001000|GOTO 04001000||
|CALL|CALL lstrcmpW|||
|PUSH|PUSH 00000001|||
|POP|POP EAX|||
