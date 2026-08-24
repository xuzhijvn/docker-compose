# DEV Vector Deployment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add one production-compatible Vector receiver to the new DEV Compose environment and initialize its ClickHouse destination on first startup.

**Architecture:** Vector listens for APISIX RFC5424 Syslog on host TCP port 5514, validates and normalizes events, and writes accepted HTTP and Stream records to ClickHouse. ClickHouse applies the `apisix` schema through its standard first-start initialization directory. The fully controlled, disposable DEV environment uses the existing `default` account and hardcoded password to keep deployment self-contained.

**Tech Stack:** Docker Compose, Vector 0.57.0, ClickHouse 25.8, YAML, SQL

**Spec:** `/Users/tonyxu/GolandProjects/dashboard/.worktrees/observability-platform/docs/superpowers/specs/2026-08-19-route-observability-design.md`

## Global Constraints

- Deploy exactly one Vector instance in DEV and publish `5514:5514/tcp` directly.
- Keep the existing ClickHouse `demo` database and persistent data directory usable.
- Store observability data in ClickHouse database `apisix`.
- Use internal plain TCP and HTTP without TLS or certificates.
- Never store request/response bodies, query strings, Authorization, or Cookie values.
- Require a platform-controlled stable `VECTOR_CLUSTER_ID`; do not infer identity from payloads.

---

### Task 1: Deploy Vector and initialize ClickHouse observability storage

**Files:**
- Modify: `dev/docker-compose.yml`
- Create: `dev/vector/vector.yaml`
- Create: `dev/vector/docker-quarantine.yaml`
- Create: `dev/clickhouse/init/001_database.sql`
- Create: `dev/clickhouse/init/002_raw_tables.sql`
- Create: `dev/clickhouse/init/003_aggregate_tables.sql`
- Create: `dev/clickhouse/init/004_materialized_views.sql`

**Interfaces:**
- Consumes: APISIX RFC5424 Syslog JSON on TCP port `5514`; APISIX Plugin Metadata uses the same hardcoded DEV cluster ID.
- Produces: `apisix.http_access_events`, `apisix.stream_session_events`, aggregate tables, and materialized views readable by Manager API.

- [x] **Step 1: Run the deployment assertion before implementation**

Run a semantic YAML assertion that loads `docker-compose.yml`, fetches `services.vector`, verifies image `timberio/vector:0.57.0-debian`, TCP port `5514`, ClickHouse health dependency, and initialization mount.

Expected: FAIL with `key not found: "vector"`.

- [x] **Step 2: Add the minimal deployment configuration**

Add a healthy ClickHouse service with first-start schema initialization, plus one `vector` service using the DEV default account, persistent disk buffers, and bounded local container logs. Reuse the audited schema and Vector pipeline from the observability deployment without changing their event contract.

- [x] **Step 3: Validate the merged deployment**

Run the semantic YAML assertion again and validate all YAML/XML/SQL artifacts. If Docker is available, additionally run `docker compose config` and `vector validate` through the pinned container image.

Expected: all available checks exit `0`; if Docker is absent, report that container-level checks could not be run.
