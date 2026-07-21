# Ruby 4 and Rails 8 upgrade runbook

## Target stack

* Ruby 4.0.6
* Rails 8.1.3
* RailsAdmin 3.3
* `discourse_api` 2.1
* PostgreSQL 18 in local development and CI

The application schema is unchanged by this release. Existing migrations were
only annotated with their original Rails version so a fresh Rails 8 database can
replay them correctly.

## Required configuration

Set `DATABASE_URL`, `SECRET_KEY_BASE`, the `AWS_S3_*` values, and the `SMTP_*`
values from `.env.example`. Set `DISCOURSE_API` and `DISCOURSE_USER` to a current
Discourse API key and its owner. Project approval deliberately fails without
those credentials so an approved project can never receive a fake topic ID.

Set `CORS_ALLOWED_ORIGINS` to a comma-separated list of exact HTTPS frontend
origins. Keep `RAILS_ASSUME_SSL=true` behind the production TLS proxy. Enable
`RAILS_FORCE_SSL` only after confirming forwarded HTTPS headers are correct.

## Staging rehearsal

1. Back up PostgreSQL and confirm the object-storage retention policy.
2. Build the exact revision that passed CI: `docker build -t infoeducatie-api:rails8 .`.
3. Deploy it to staging without changing PostgreSQL or Discourse at the same time.
4. Run `bundle exec rails db:migrate` once, then start Puma.
5. Verify `/up`, login, registration, public API payloads, and RailsAdmin access.
6. Create and edit a project, add/replace/remove screenshots, and save the form.
7. Against staging Discourse, approve a temporary project, edit it, reject it,
   and confirm topic creation, update, recategorization, and deletion.
8. Create and edit news with text and an uploaded image. Confirm the uploaded URL
   is readable after a container restart.

Upgrade Discourse only after the new API has passed this rehearsal against the
existing Discourse version. Then repeat step 7 against the upgraded staging
instance before touching production.

## Production rollout

1. Record the current application image digest and take a fresh database backup.
2. Confirm S3 credentials, Discourse credentials, SMTP, CORS, and `SECRET_KEY_BASE`.
3. Deploy one new application instance and run `bundle exec rails db:migrate`.
4. Check `/up` and the logs, then complete the staging smoke paths once.
5. Shift traffic gradually and monitor HTTP 5xx, Sentry, database connections,
   mail delivery, and Discourse API errors.

Keep the PostgreSQL and Discourse upgrades as separate maintenance events. This
makes failures attributable and rollback practical.

## Rollback

Restore the previous application image digest and restart Puma. Because this
release does not change the database structure, no down migration is required.
If data was damaged independently of the application deployment, stop writes and
restore the verified PostgreSQL backup using the normal infrastructure procedure.
