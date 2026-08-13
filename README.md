# infoeducatie-api

[![Run tests](https://github.com/infoeducatie/infoeducatie-api/actions/workflows/test.yaml/badge.svg?branch=master)](https://github.com/infoeducatie/infoeducatie-api/actions/workflows/test.yaml)

## Installation

### Prerequisites

* Ruby 4.0.6
* PostgreSQL
* ImageMagick

### Getting Started

After you have pulled the repo run:

1. `bundle install`
2. `bin/rails db:prepare`
3. `bin/rails db:seed`
4. `bin/rails server`

### Docker

Start the application and PostgreSQL with:

```sh
docker compose up --build
```

The local Compose setup seeds an entirely fictional 2026 dataset: first-place
projects and participants from every category, results, news and alumni. Names,
schools, biographies, scores, URLs and required private fields are all invented.
Set `SEED_DEMO_DATA=false` to start with only the core roles, categories and
current edition.

The adjacent UI repository runs with `npm run dev` at
<http://localhost:3001> and connects to this local API automatically. RailsAdmin
is available at <http://localhost:3000/internal/admin> with the local defaults
`admin@example.test` / `infoedu-local-admin`. Override `ADMIN_EMAIL` and
`ADMIN_PASSWORD` in `.env` if needed.

Successful `master` builds are published to GitHub Container Registry.

Service-to-service exports use scoped, expiring API credentials managed from
RailsAdmin. See [API.md](API.md) for the integration endpoints, including the
competition-results update and conclusion contract.

### New contest edition

Due to a missing feature after creating a new edition, all the existing users need to be updated.

 ```
 User.joins("contestants":"edition").where("contestants":{"edition":1}).each {|u| u.update_attribute(:registration_step_number, 1)}
 ```
