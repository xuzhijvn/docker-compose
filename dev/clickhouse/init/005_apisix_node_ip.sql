ALTER TABLE apisix.http_access_events
    ADD COLUMN IF NOT EXISTS apisix_node_ip IPv6 AFTER client_ip;

ALTER TABLE apisix.http_access_events
    MODIFY COLUMN apisix_node_ip IPv6;

ALTER TABLE apisix.stream_session_events
    ADD COLUMN IF NOT EXISTS apisix_node_ip IPv6 AFTER client_ip;

ALTER TABLE apisix.stream_session_events
    MODIFY COLUMN apisix_node_ip IPv6;
