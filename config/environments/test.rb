Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = ENV["CI"].present?
  config.public_file_server.headers = {"cache-control" => "public, max-age=3600"}

  config.consider_all_requests_local = true
  config.cache_store = :null_store
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = :none
  config.action_controller.allow_forgery_protection = false

  config.action_mailer.delivery_method = :test
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = {host: "devel.localhost"}

  config.active_support.deprecation = :stderr
end
