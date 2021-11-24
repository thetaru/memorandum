# syslogクライアントの構築
## ■ 注意事項
rsyslogが受け取るログはjounaldから渡されたものなので、journaldに貯められているログの扱いに注意するべきです。  
デフォルトだと/runの容量の10%が保存可能で、それを超えるとローテーションがはじまります。  
容量上限によりローテートされると、`Warning: Journal has been rotated since unit was started. Log output is incomplete or unavailable`と出力されます。
