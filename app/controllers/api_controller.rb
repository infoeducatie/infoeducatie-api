class ApiController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :set_content_locale

  private

  def set_content_locale
    requested_locale = params[:locale].presence ||
      request.headers["Accept-Language"].to_s.split(",").first
    @content_locale = requested_locale.to_s.downcase.start_with?("en") ? :en : :ro
  end

  def require_registration_open
    edition = Edition.get_current
    now = Time.current

    return if edition &&
      edition.registration_start_date <= now &&
      edition.registration_end_date >= now

    render json: {error: "unauthorized"}, status: :unauthorized
  end
end
