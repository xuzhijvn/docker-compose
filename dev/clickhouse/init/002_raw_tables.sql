CREATE TABLE IF NOT EXISTS apisix.http_access_events
(
    event_id String,
    event_time DateTime64(3, 'UTC'),
    received_at DateTime64(3, 'UTC'),
    cluster_id String,
    workspace_id String,
    route_id String,
    route_name String DEFAULT '',
    client_ip IPv6,
    apisix_node_ip IPv6,
    request_id String DEFAULT '',
    trace_id String DEFAULT '',
    schema_version UInt16 DEFAULT 1,
    attributes Map(String, String),
    method LowCardinality(String),
    scheme LowCardinality(String),
    host String,
    path String,
    status UInt16,
    request_bytes UInt64,
    response_bytes UInt64,
    duration_ms UInt64,
    upstream_duration_ms Nullable(UInt64),
    upstream_address String,
    protocol_version LowCardinality(String)
)
ENGINE = ReplacingMergeTree(received_at)
PARTITION BY toYYYYMMDD(event_time)
ORDER BY (cluster_id, workspace_id, route_id, event_time, client_ip, event_id)
TTL event_time + INTERVAL 30 DAY DELETE;

CREATE TABLE IF NOT EXISTS apisix.stream_session_events
(
    event_id String,
    event_time DateTime64(3, 'UTC'),
    received_at DateTime64(3, 'UTC'),
    cluster_id String,
    workspace_id String,
    route_id String,
    route_name String DEFAULT '',
    client_ip IPv6,
    apisix_node_ip IPv6,
    request_id String DEFAULT '',
    trace_id String DEFAULT '',
    schema_version UInt16 DEFAULT 1,
    attributes Map(String, String),
    session_start_time Nullable(DateTime64(3, 'UTC')),
    client_port UInt16,
    server_port UInt16,
    transport_protocol LowCardinality(String),
    duration_ms Nullable(UInt64),
    upstream_bytes UInt64,
    downstream_bytes UInt64,
    upstream_address String,
    connection_result LowCardinality(String),
    sni String,
    tls_version LowCardinality(String),
    tls_cipher String
)
ENGINE = ReplacingMergeTree(received_at)
PARTITION BY toYYYYMMDD(event_time)
ORDER BY (cluster_id, workspace_id, route_id, event_time, client_ip, event_id)
TTL event_time + INTERVAL 30 DAY DELETE;
