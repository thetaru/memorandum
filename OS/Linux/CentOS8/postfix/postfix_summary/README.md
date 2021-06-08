# /etc/postfix/main.cf
デフォルト値については`postconf -d`で確認すること。  
https://exfield.jp/View/pid:1018/  
http://www.postfix.org/postconf.5.html

## (option) 2bounce_notice_recipient
|デフォルト値|対応バージョン|
|:---|:---|
|postmaster|any|
## (option) access_map_defer_code
## (option) access_map_reject_code
## (option) address_verify_cache_cleanup_interval
## (option) address_verify_local_transport
## (option) address_verify_map
## () address_verify_negative_cache
## () address_verify_expire_time
## () address_verify_negative_refresh_time
## () address_verify_pending_request_limit
## () address_verify_poll_count
## () address_verify_poll_delay
## () address_verify_positive_expire_time
## () address_verify_positive_refresh_time
## () address_verify_relay_transport
## () address_verify_relayhost
## () address_verify_sender
## () address_verify_sender_dependent_default_transport_maps
## () address_verify_sender_dependent_relayhost_maps
## () address_verify_sender_ttl
