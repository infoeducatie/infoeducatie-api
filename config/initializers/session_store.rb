secure_session_cookie = ENV.fetch("SESSION_COOKIE_SECURE") do
  (Rails.env.production? || Rails.env.staging?).to_s
end == "true"

Rails.application.config.session_store :cookie_store,
  key: "_infoeducatie_session",
  secure: secure_session_cookie,
  httponly: true,
  same_site: :lax
