CREATE MATERIALIZED VIEW IF NOT EXISTS apisix.http_route_minute_metrics_mv
TO apisix.route_minute_metrics
AS
SELECT
    cluster_id,
    workspace_id,
    route_id,
    'http' AS protocol,
    toStartOfMinute(event_time) AS bucket_time,
    sumState(toUInt64(1)) AS event_count,
    sumState(toUInt64(status BETWEEN 400 AND 599)) AS error_count,
    sumState(request_bytes) AS ingress_bytes,
    sumState(response_bytes) AS egress_bytes,
    avgState(toNullable(duration_ms)) AS duration_avg,
    quantilesTDigestState(0.5, 0.9, 0.95, 0.99)(
        toNullable(duration_ms)
    ) AS duration_quantiles
FROM apisix.http_access_events
GROUP BY cluster_id, workspace_id, route_id, bucket_time;

CREATE MATERIALIZED VIEW IF NOT EXISTS apisix.stream_route_minute_metrics_mv
TO apisix.route_minute_metrics
AS
SELECT
    cluster_id,
    workspace_id,
    route_id,
    'stream' AS protocol,
    toStartOfMinute(event_time) AS bucket_time,
    sumState(toUInt64(1)) AS event_count,
    sumState(toUInt64(connection_result NOT IN ('', 'success', '200'))) AS error_count,
    sumState(upstream_bytes) AS ingress_bytes,
    sumState(downstream_bytes) AS egress_bytes,
    avgState(duration_ms) AS duration_avg,
    quantilesTDigestState(0.5, 0.9, 0.95, 0.99)(duration_ms) AS duration_quantiles
FROM apisix.stream_session_events
GROUP BY cluster_id, workspace_id, route_id, bucket_time;

CREATE MATERIALIZED VIEW IF NOT EXISTS apisix.http_route_ip_hourly_metrics_mv
TO apisix.route_ip_hourly_metrics
AS
SELECT
    cluster_id,
    workspace_id,
    route_id,
    'http' AS protocol,
    client_ip,
    toStartOfHour(event_time) AS bucket_time,
    sumState(toUInt64(1)) AS event_count,
    sumState(toUInt64(status BETWEEN 400 AND 599)) AS error_count,
    sumState(request_bytes) AS ingress_bytes,
    sumState(response_bytes) AS egress_bytes
FROM apisix.http_access_events
GROUP BY cluster_id, workspace_id, route_id, client_ip, bucket_time;

CREATE MATERIALIZED VIEW IF NOT EXISTS apisix.stream_route_ip_hourly_metrics_mv
TO apisix.route_ip_hourly_metrics
AS
SELECT
    cluster_id,
    workspace_id,
    route_id,
    'stream' AS protocol,
    client_ip,
    toStartOfHour(event_time) AS bucket_time,
    sumState(toUInt64(1)) AS event_count,
    sumState(toUInt64(connection_result NOT IN ('', 'success', '200'))) AS error_count,
    sumState(upstream_bytes) AS ingress_bytes,
    sumState(downstream_bytes) AS egress_bytes
FROM apisix.stream_session_events
GROUP BY cluster_id, workspace_id, route_id, client_ip, bucket_time;

CREATE MATERIALIZED VIEW IF NOT EXISTS apisix.http_workspace_daily_usage_mv
TO apisix.workspace_daily_usage
AS
SELECT
    cluster_id,
    workspace_id,
    'http' AS protocol,
    toDate(event_time) AS bucket_date,
    sumState(toUInt64(1)) AS event_count,
    sumState(toUInt64(status BETWEEN 400 AND 599)) AS error_count,
    sumState(request_bytes) AS ingress_bytes,
    sumState(response_bytes) AS egress_bytes
FROM apisix.http_access_events
GROUP BY cluster_id, workspace_id, bucket_date;

CREATE MATERIALIZED VIEW IF NOT EXISTS apisix.stream_workspace_daily_usage_mv
TO apisix.workspace_daily_usage
AS
SELECT
    cluster_id,
    workspace_id,
    'stream' AS protocol,
    toDate(event_time) AS bucket_date,
    sumState(toUInt64(1)) AS event_count,
    sumState(toUInt64(connection_result NOT IN ('', 'success', '200'))) AS error_count,
    sumState(upstream_bytes) AS ingress_bytes,
    sumState(downstream_bytes) AS egress_bytes
FROM apisix.stream_session_events
GROUP BY cluster_id, workspace_id, bucket_date;
