# /etc/postfix/main.cf
デフォルト値については`postconf -d`で確認すること。  

## ■ Required
### compatibility_level
### header_checks
### inet_interfaces (★)
### inet_protocols (★)
### local_recipient_maps
### mydestination (★)
### mydomain (★)
### myhostname (★)
### myorigin (★)
### mynetworks (★)
### relay_domains (★)
### relay_recipient_maps
### relayhost (★)
### smtp_tls_security_level
### smtp_use_tls
### smtpd_banner (★)
### smtpd_tls_cert_file
### smtpd_tls_key_file
### smtpd_tls_security_level

## ■ Option
### biff (★)
### body_checks
### body_checks_size_limit
### canonical_classes
### canonical_maps
### canonical_classes
### canonical_maps
### disable_vrfy_command
### smtpd_client_restrictions
### smtpd_recipient_restrictions
### smtpd_sender_restrictions
### smtpd_use_tls
