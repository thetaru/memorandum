# search/domainについて
resolv.confに記述するsearch/domainについての補足です。  
どちらの設定も名前解決の際、指定したドメインを付加して実行します。
## domain
ドメインを１つだけとれます。  
主に所属ドメインを指定します。
```
domain example.com
```

## search
ドメインを複数(最大6つ)とれます。  
ドメインを2つ以上指定した場合、優先順位は引数の順番に依存します。(引数の順番が若いほど優先されます)  
また、
主に複数の所属ドメインのサブドメインを指定する際に使います。
```
domain example.com
search s1.example.com s2.example.com
```

## searchとdomainの優先順位
searchが優先されます。
