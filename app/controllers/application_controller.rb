class ApplicationController < ActionController::Base
  include Pundit::Authorization

  protect_from_forgery with: :exception

  before_action :set_locale

  private

  def set_locale
    requested_locale = params[:locale].to_s
    available_locale = I18n.available_locales.find { |locale| locale.to_s == requested_locale }
    I18n.locale = available_locale || I18n.default_locale
  end

  def authenticate_user_from_token!
    authentication_error unless authenticate_user_from_token
  end

  def authenticate_user_from_token
    auth_token = request.headers["Authorization"].to_s.sub(/\ABearer\s+/i, "")
    user_id, separator, = auth_token.partition(":")
    return false if separator.empty?

    user = User.find_by(id: user_id)
    return false if user&.access_token.blank?
    return false unless user.access_token.bytesize == auth_token.bytesize
    return false unless ActiveSupport::SecurityUtils.secure_compare(user.access_token, auth_token)

    sign_in(:user, user, store: false)
    true
  end

  def authentication_error
    render json: {error: "unauthorized"}, status: :unauthorized
  end
end
