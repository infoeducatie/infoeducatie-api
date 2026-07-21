configured_origins = ENV["CORS_ALLOWED_ORIGINS"]
allowed_origins = if configured_origins.present?
  configured_origins.split(",").map(&:strip)
else
  ui_origin = Settings.ui.url.to_s.delete_suffix("/")
  [ui_origin, ui_origin.sub(%r{\Ahttp://}, "https://")].uniq
end

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(*allowed_origins)
    resource "/v1/*",
      headers: :any,
      methods: %i[get post put patch delete options head],
      max_age: 1.day.to_i
  end
end
