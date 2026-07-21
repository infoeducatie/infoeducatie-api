Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false

  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.assets.compile = false

  config.assume_ssl = ENV.fetch("RAILS_ASSUME_SSL", "true") == "true"
  config.force_ssl = ENV.fetch("RAILS_FORCE_SSL", "false") == "true"

  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.logger($stdout)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  config.cache_store = :memory_store

  config.action_mailer.default_url_options = {
    host: ENV.fetch("APP_HOST", "api.infoeducatie.ro"),
    protocol: "https"
  }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = ENV["DISABLE_EMAIL"] != "true"
  config.action_mailer.smtp_settings = {
    address: ENV["SMTP_HOST"],
    port: ENV.fetch("SMTP_PORT", 587),
    user_name: ENV["SMTP_USERNAME"],
    password: ENV["SMTP_PASSWORD"],
    authentication: ENV.fetch("SMTP_AUTHENTICATION", "plain"),
    enable_starttls_auto: true
  }

  config.i18n.fallbacks = true
  config.active_record.dump_schema_after_migration = false
end
