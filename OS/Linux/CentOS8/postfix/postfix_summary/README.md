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
## () address_verify_service_name
## () address_verify_transport_maps
## () address_verify_virtual_transport
## () alias_database
## () alias_maps
## () allow_mail_to_commands
## () allow_min_user
## () allow_percent_hack
## () allow_untrusted_routing
## () alternate_config_directories
## () always_add_missing_headers
## () always_bcc
## () anvil_rate_time_unit
## () anvil_status_update_time
## () append_at_myorigin
## () append_dot_mydomain
## () application_event_drain_time
## () authorized_flush_users
## () authorized_mailq_users
## () authorized_submit_users
## () authorized_verp_clients
## () backwards_bounce_logfile_compatibility
## () berkeley_db_create_buffer_size
## () berkeley_db_read_buffer_size
## () best_mx_transport
## (recommended) biff
## () body_checks
## () body_checks_size_limit
## () bounce_notice_recipient
## () bounce_queue_lifetime
## () bounce_service_name
## () bounce_size_limit
## () bounce_template_file
## () broken_sasl_auth_clients
## (recommended) canonical_classes
## (recommended) canonical_maps
## () cleanup_service_name
## () command_directory
## () command_execution_directory
## () command_expansion_filter
## () command_time_limit
## (required) compatibility_level
## () config_directory
## () confirm_delay_cleared
## () connection_cache_protocol_timeout
## () connection_cache_service_name
## () connection_cache_status_update_time
## () connection_cache_ttl_limit
l# () content_filter
l# () cyrus_sasl_config_path
## () daemon_directory
## () daemon_table_open_error_is_fatal
## () daemon_timeout
## () data_directory
## () debug_peer_level
## () debug_peer_list
## () debugger_command
## () default_database_type
## () default_delivery_slot_cost
