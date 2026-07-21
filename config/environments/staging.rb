require_relative "production"

Rails.application.configure do
  config.action_mailer.default_url_options = {
    host: ENV.fetch("APP_HOST", "api.staging.infoeducatie.ro"),
    protocol: "https"
  }
end
