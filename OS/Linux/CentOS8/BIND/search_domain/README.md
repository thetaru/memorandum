# search/domainについて
resolv.confに記述するsearch/domainについての補足です。  
どちらの設定も名前解決の際、指定したドメインを付加して実行します。
## domain
ドメインを１つだけとれます。  
所属ドメインを指定します。
```
domain example.com
```

## search
ドメインを複数(最大6つ)とれます。  
ドメインを2つ以上指定した場合、優先順位は引数の順番が若いほど高くなります。  
検索リストとして複数のドメインを指定します。
```
search example.com s1.example.com s2.example.com
```

## searchとdomainの優先順位
searchとdomainを同時に記述すると、最後に記述した方のみ適用されます。(適用されなかった方のドメインを付加した名前解決は行われない)  
※ ソースは`man resolv.conf`

## manによると
```
The domain and search keywords are mutually exclusive.  
if more than one instance of them keywords is present, the last instance wins.
```

## まとめ
引くだけならsearchで十分だが、所属ドメインを主張したいならdomainを記載するべきかも。
