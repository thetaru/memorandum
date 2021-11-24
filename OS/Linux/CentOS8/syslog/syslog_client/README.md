# syslogクライアントの構築
## ■ 注意事項
アクセスログ(http系)やクエリログ(dns系)など大量のログをrsyslogで扱う場合は注意が必要です。  
※ 転送先に送られたログはjournaldで受けず、rsyslogで受けるため影響はない模様  
ローカルでは、rsyslogが受け取るログはjounaldから渡されたものなので、journaldに貯められているログの扱いに注意します。  
journaldはログがディスクを圧迫しないようにローテーション機能を持っており、しきい値を超えるとローテーションを開始します。  
ローテーションしたことで消えたログを(systemctl statusなどで)参照しようとすると以下のエラーが出力されます。
> Warning: Journal has been rotated since unit was started. Log output is incomplete or unavailable
