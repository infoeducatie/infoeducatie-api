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

Successful `master` builds are published to GitHub Container Registry.

Service-to-service exports use scoped, expiring API credentials managed from
RailsAdmin.

### New contest edition

Due to a missing feature after creating a new edition, all the existing users need to be updated.

 ```
 User.joins("contestants":"edition").where("contestants":{"edition":1}).each {|u| u.update_attribute(:registration_step_number, 1)}
 ```
