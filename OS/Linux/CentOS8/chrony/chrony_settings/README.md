## NTPクライアントとしての設定
https://qiita.com/yunano/items/7883cf295f91f4ef716b
### Syntax - server
```
server <NTPサーバ> [<option1> <option2> ... ]
```
NTPクライアントとしてどのNTPサーバに時刻を問い合わせに行くかを指定します。  
  
`iburst`オプションをつけることで、起動直後に指定のNTPサーバへ4回問い合わせをします。  
NTPサーバの妥当性の判断には数回の問い合わせが必要なため、起動から時刻同期が行われるまでの時間が短くなります。
