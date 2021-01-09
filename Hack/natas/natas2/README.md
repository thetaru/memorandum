# NATAS2

- Username: natas2
- Password: ZluruAthQk7Q2MqmDeTiUij2ZvWy2mBi
- URL: http://natas2.natas.labs.overthewire.org

```
$ curl -u natas2:ZluruAthQk7Q2MqmDeTiUij2ZvWy2mBi http://natas2.natas.labs.overthewire.org
```
```html
<html>
<head>
<!-- This stuff in the header has nothing to do with the level -->
<link rel="stylesheet" type="text/css" href="http://natas.labs.overthewire.org/css/level.css">
<link rel="stylesheet" href="http://natas.labs.overthewire.org/css/jquery-ui.css" />
<link rel="stylesheet" href="http://natas.labs.overthewire.org/css/wechall.css" />
<script src="http://natas.labs.overthewire.org/js/jquery-1.9.1.js"></script>
<script src="http://natas.labs.overthewire.org/js/jquery-ui.js"></script>
<script src=http://natas.labs.overthewire.org/js/wechall-data.js></script><script src="http://natas.labs.overthewire.org/js/wechall.js"></script>
<script>var wechallinfo = { "level": "natas2", "pass": "ZluruAthQk7Q2MqmDeTiUij2ZvWy2mBi" };</script></head>
<body>
<h1>natas2</h1>
<div id="content">
There is nothing on this page
<img src="files/pixel.png">
</div>
</body></html>
```
`file/pixel.png`というファイルがあるので見てみる。(画像を見たらまずステガノグラフィを疑いましょう。)
```
$ curl -sS -u natas2:ZluruAthQk7Q2MqmDeTiUij2ZvWy2mBi http://natas2.natas.labs.overthewire.org/files/pixel.png | hexdump -C
```
```
00000000  89 50 4e 47 0d 0a 1a 0a  00 00 00 0d 49 48 44 52  |.PNG........IHDR|
00000010  00 00 00 01 00 00 00 01  01 03 00 00 00 25 db 56  |.............%.V|
00000020  ca 00 00 00 04 67 41 4d  41 00 00 b1 8f 0b fc 61  |.....gAMA......a|
00000030  05 00 00 00 01 73 52 47  42 00 ae ce 1c e9 00 00  |.....sRGB.......|
00000040  00 20 63 48 52 4d 00 00  7a 26 00 00 80 84 00 00  |. cHRM..z&......|
00000050  fa 00 00 00 80 e8 00 00  75 30 00 00 ea 60 00 00  |........u0...`..|
00000060  3a 98 00 00 17 70 9c ba  51 3c 00 00 00 06 50 4c  |:....p..Q<....PL|
00000070  54 45 ff ff ff ff ff ff  55 7c f5 6c 00 00 00 01  |TE......U|.l....|
00000080  74 52 4e 53 00 40 e6 d8  66 00 00 00 01 62 4b 47  |tRNS.@..f....bKG|
00000090  44 00 88 05 1d 48 00 00  00 09 70 48 59 73 00 00  |D....H....pHYs..|
000000a0  00 48 00 00 00 48 00 46  c9 6b 3e 00 00 00 0a 49  |.H...H.F.k>....I|
000000b0  44 41 54 08 d7 63 60 00  00 00 02 00 01 e2 21 bc  |DAT..c`.......!.|
000000c0  33 00 00 00 25 74 45 58  74 64 61 74 65 3a 63 72  |3...%tEXtdate:cr|
000000d0  65 61 74 65 00 32 30 31  32 2d 30 39 2d 31 37 54  |eate.2012-09-17T|
000000e0  31 35 3a 32 34 3a 32 33  2b 30 32 3a 30 30 f8 56  |15:24:23+02:00.V|
000000f0  a6 11 00 00 00 25 74 45  58 74 64 61 74 65 3a 6d  |.....%tEXtdate:m|
00000100  6f 64 69 66 79 00 32 30  30 38 2d 30 31 2d 30 32  |odify.2008-01-02|
00000110  54 32 33 3a 31 33 3a 30  38 2b 30 31 3a 30 30 84  |T23:13:08+01:00.|
00000120  18 6b 3e 00 00 00 00 49  45 4e 44 ae 42 60 82     |.k>....IEND.B`.|
```
出力からステガノグラフィではないとわかるので、`files`の中を見てみる。
```
$ curl -u natas2:ZluruAthQk7Q2MqmDeTiUij2ZvWy2mBi http://natas2.natas.labs.overthewire.org/files/
```
```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
 <head>
  <title>Index of /files</title>
 </head>
 <body>
<h1>Index of /files</h1>
  <table>
   <tr><th valign="top"><img src="/icons/blank.gif" alt="[ICO]"></th><th><a href="?C=N;O=D">Name</a></th><th><a href="?C=M;O=A">Last modified</a></th><th><a href="?C=S;O=A">Size</a></th><th><a href="?C=D;O=A">Description</a></th></tr>
   <tr><th colspan="5"><hr></th></tr>
<tr><td valign="top"><img src="/icons/back.gif" alt="[PARENTDIR]"></td><td><a href="/">Parent Directory</a></td><td>&nbsp;</td><td align="right">  - </td><td>&nbsp;</td></tr>
<tr><td valign="top"><img src="/icons/image2.gif" alt="[IMG]"></td><td><a href="pixel.png">pixel.png</a></td><td align="right">2016-12-15 16:07  </td><td align="right">303 </td><td>&nbsp;</td></tr>
<tr><td valign="top"><img src="/icons/text.gif" alt="[TXT]"></td><td><a href="users.txt">users.txt</a></td><td align="right">2016-12-20 05:15  </td><td align="right">145 </td><td>&nbsp;</td></tr>
   <tr><th colspan="5"><hr></th></tr>
</table>
<address>Apache/2.4.10 (Debian) Server at natas2.natas.labs.overthewire.org Port 80</address>
</body></html>
```
すると、`pixel.png`と`users.txt`があることがわかりました。
```
$ curl -u natas2:ZluruAthQk7Q2MqmDeTiUij2ZvWy2mBi http://natas2.natas.labs.overthewire.org/files/users.txt
```
```
# username:password
alice:BYNdCesZqW
bob:jw2ueICLvT
charlie:G5vCxkVV3m
natas3:sJIJNW6ucpu6HPZ1ZAchaDtwd7oGrD14
eve:zo4mJWyNj2
mallory:9urtcpzBmH
```
テキストファイルの中にpassword(`sJIJNW6ucpu6HPZ1ZAchaDtwd7oGrD14`)が書いてある。
