CREATE TABLE IF NOT EXISTS apisix.route_minute_metrics
(
    cluster_id String,
    workspace_id String,
    route_id String,
    protocol LowCardinality(String),
    bucket_time DateTime('UTC'),
    event_count AggregateFunction(sum, UInt64),
    error_count AggregateFunction(sum, UInt64),
    ingress_bytes AggregateFunction(sum, UInt64),
    egress_bytes AggregateFunction(sum, UInt64),
    duration_avg AggregateFunction(avg, Nullable(UInt64)),
    duration_quantiles AggregateFunction(
        quantilesTDigest(0.5, 0.9, 0.95, 0.99),
        Nullable(UInt64)
    )
)
ENGINE = AggregatingMergeTree()
PARTITION BY toYYYYMM(bucket_time)
ORDER BY (cluster_id, workspace_id, route_id, protocol, bucket_time)
TTL bucket_time + INTERVAL 90 DAY DELETE;

CREATE TABLE IF NOT EXISTS apisix.route_ip_hourly_metrics
(
    cluster_id String,
    workspace_id String,
    route_id String,
    protocol LowCardinality(String),
    client_ip IPv6,
    bucket_time DateTime('UTC'),
    event_count AggregateFunction(sum, UInt64),
    error_count AggregateFunction(sum, UInt64),
    ingress_bytes AggregateFunction(sum, UInt64),
    egress_bytes AggregateFunction(sum, UInt64)
)
ENGINE = AggregatingMergeTree()
PARTITION BY toYYYYMM(bucket_time)
ORDER BY (cluster_id, workspace_id, route_id, protocol, client_ip, bucket_time)
TTL bucket_time + INTERVAL 30 DAY DELETE;

CREATE TABLE IF NOT EXISTS apisix.workspace_daily_usage
(
    cluster_id String,
    workspace_id String,
    protocol LowCardinality(String),
    bucket_date Date,
    event_count AggregateFunction(sum, UInt64),
    error_count AggregateFunction(sum, UInt64),
    ingress_bytes AggregateFunction(sum, UInt64),
    egress_bytes AggregateFunction(sum, UInt64)
)
ENGINE = AggregatingMergeTree()
PARTITION BY toYYYYMM(bucket_date)
ORDER BY (cluster_id, workspace_id, protocol, bucket_date)
TTL bucket_date + INTERVAL 365 DAY DELETE;
