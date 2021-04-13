# cache.confのテンプレート
設定例です。環境に応じて読み替えてください。
```
# メモリ上のキャッシュ総量を増やす
cache_mem 2048 MB

# メモリ上に保存するキャッシュの最大値
# この値を越えるサイズのファイルはキャッシュとして保存しない
maximum_object_size_in_memory 20480 KB

# ディスク上に保存するキャッシュの最大値
maximum_object_size 20480 KB

# IPアドレスからFQDNに名前解決をした結果のキャッシュのエントリー数
fqdncache_size 10000

# FQDNからIPアドレスに名前解決をした結果のキャッシュのエントリー数
ipcache_size 10000

# cgi-bin と ? を含むURLのキャッシュをしない
hierarchy_stoplist cgi-bin ?

# ディスク上のキャッシュディレクトリの設定
# ストレージ書き込みの方式はaufs
# 格納先ディレクトリは/var/spool/squid
# ディスクキャッシュは300MB
# 階層ごとのディレクトリの数はそれぞれ32と512
cache_dir aufs /var/spool/squid 30000 32 512
```
