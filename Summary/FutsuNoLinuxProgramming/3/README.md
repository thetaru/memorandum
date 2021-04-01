# Linuxを描き出す3つの概念
## 3.1 ファイルシステム
## 3.1.1 ファイル
ファイルシステムとは、ファイルという概念を成立させているシステムです。  
ファイルとは、主に3つの意味で使われます。
1. 広義のファイル
2. 狭義のファイル(regular file)
3. ストリーム

以下それぞれのファイルについて説明します。
## 3.1.2 広義のファイル
まず、適当なディレクトリをlsしてください。
```
# ls /etc
```
```
DIR_COLORS                  firefox                   man_db.conf        resolv.conf
DIR_COLORS.256color         firewalld                 mcelog             rhsm
DIR_COLORS.lightbgcolor     flatpak                   microcode_ctl      rpc
GREP_COLORS                 fonts                     mime.types         rpm
NetworkManager              fprintd.conf              mke2fs.conf        rsyslog.conf
<以下省略>
```
ここにはテキストファイル、バイナリファイル、ディレクトリ、シンボリックリンクもあります。  
普段はこれらを区別して別物だと思いますが、実はこれらすべてファイルです。  
これらを広義のファイルと呼ぶことにします。
