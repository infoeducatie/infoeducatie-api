# Integration API

The integration API uses service credentials, not user accounts. An API key
does not impersonate an InfoEducatie user and cannot be used with registration
or admin endpoints.

## Issue and rotate keys

Administrators can open **Security > API keys** in RailsAdmin and select
**Issue API key**. Every key:

* is shown once and stored only as an HMAC-SHA-256 digest;
* has immutable scopes and expiry, with a lifetime of at most one year;
* can be revoked immediately;
* records its last-use timestamp, source IP, and use count;
* is rate limited independently from browser user sessions.

Store the plaintext key in the consuming service's secret manager. Never put it
in source control, query parameters, client-side JavaScript, analytics, or log
messages. To rotate a key, issue the replacement first, update the consumer,
verify it, and revoke the old key.

Set `API_KEY_PEPPER` to a long random production secret kept separately from the
database. If omitted, the API falls back to `SECRET_KEY_BASE`. Changing either
value invalidates the keys whose digests depend on it.

## Authentication

Send the key only in the standard bearer authorization header:

```http
Authorization: Bearer ie_api_IDENTIFIER.SECRET
```

Missing, malformed, expired, or revoked keys return `401`. A valid key without
the endpoint's required scope returns `403` and identifies the required scope.
Production rejects non-HTTPS requests before reading a key. Responses are
marked `private, no-store`.

## Scopes

| Scope | Access |
| --- | --- |
| `competitions:read` | List competitions, years, dates, and aggregate counts |
| `competition_data:read` | Read participants and all projects for one competition |
| `participants:personal_data:read` | Include participant contact and identity data |

The personal-data scope also requires `competition_data:read`. Grant it only to
systems that have an approved need for CNP, identity-document, address, phone,
email, sex, and birth-date data.

## List competitions

```http
GET /v1/integrations/competitions
GET /v1/integrations/competitions?year=2026
```

Required scope: `competitions:read`.

The response contains stable competition IDs, years, publication state, camp
and registration dates, and participant/project counts:

```json
{
  "data": [
    {
      "id": 31,
      "year": 2026,
      "name": "Olimpiada Nationala 2026",
      "published": true,
      "current": true,
      "counts": {
        "participants": 120,
        "projects": 68,
        "approved_projects": 61
      }
    }
  ],
  "meta": {
    "count": 1,
    "generated_at": "2026-07-23T12:00:00.000+03:00"
  }
}
```

## Export a competition dataset

Select exactly one stable ID or year:

```http
GET /v1/integrations/competition_data?competition_id=31
GET /v1/integrations/competition_data?year=2026
```

Required scope: `competition_data:read`.

The response contains the competition, every participant, and every project
regardless of project approval status. Participant and project IDs express the
many-to-many relationship in both directions. Personal contact and identity
fields are omitted by default.

If more than one competition exists for a year, the API returns `409` with the
matching competition IDs. Consumers should persist and use the stable ID from
the competitions endpoint.

### Explicit personal-data export

```http
GET /v1/integrations/competition_data?competition_id=31&include=personal_data
```

This additionally requires `participants:personal_data:read`. Without that
scope the request returns `403`; the API never silently exposes sensitive
fields.

## Operational guidance

The default rate limit is 300 requests per authenticated key per minute and can
be configured with `INTEGRATION_API_RATE_LIMIT`. Rejected authentication
attempts are limited by source IP. The budget is shared across integration
endpoints. Treat `429` as retryable and respect the `Retry-After` header. Treat
`401` as a rotation/revocation issue and `403` as a scope configuration issue.

The application limiter uses the configured Rails cache store. Deployments
with multiple Puma processes or replicas must enforce an equivalent shared
limit at the reverse proxy/API gateway or configure a shared cache store.

Monitor key use from RailsAdmin and revoke credentials that are unused,
unexpectedly active, or no longer owned by a known integration.
