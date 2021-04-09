# ファイルディスクリプタ数の拡張
Squidは、キャッシュファイルやソケットファイルを大量に扱うため、OSのリソース制限によりSquidプロセスがファイルにアクセスできなくなり、サービスが停止してしまうことがあります。  
ファイルディスクリプタ数の最大値を修正し、大量のキャッシュファイルを扱えるようにします。
変更方法については[このページ](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/filedescriptor)を参考にしてください。
