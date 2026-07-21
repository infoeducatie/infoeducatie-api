class ApiController < ApplicationController
  protect_from_forgery with: :null_session

  private

  def require_registration_open
    edition = Edition.get_current
    now = Time.current

    return if edition &&
      edition.registration_start_date <= now &&
      edition.registration_end_date >= now

    render json: {error: "unauthorized"}, status: :unauthorized
  end
end
