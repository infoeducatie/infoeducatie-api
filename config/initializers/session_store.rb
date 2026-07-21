Rails.application.config.session_store :cookie_store,
  key: "_infoeducatie_session",
  secure: Rails.env.production? || Rails.env.staging?,
  httponly: true,
  same_site: :lax
