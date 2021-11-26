# フォーワード設定について
forwardは一種の再起問い合わせのため、再起問い合わせ(recursion yes)を有効にする必要があることに注意します。  
その際、再起問い合わせを許可するクライアントを制限するのを忘れないこと。  
主にキャッシュDNSサーバがする設定の認識です。
```
options {
    <snip>
    recursion yes;                     // 再起問い合わせの有効化
    allow-recursion { internalnet; };  // 再起問い合わせを許可するクライアント
    <snip>
    zone "example.com." IN {
        type forward;
        forward only;
        forwarders {
            192.168.138.1;             // フォワード先DNSサーバ
            192.168.138.2;             // フォワード先DNSサーバ
        };
    };
};
```
フォワード先DNSサーバがDNSSECに対応していない場合、DNSSECを無効化します。
```
options {
    <snip>
    dnssec-enable no;
    dnssec-validation no;
    <snip>
};
```
