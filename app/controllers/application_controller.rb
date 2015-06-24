class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :null_session

  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def ensure_json_request
    return if params[:format] == "json" || request.headers["Accept"] =~ /json/

    render :json => {:status => 404, :error => "Not Found"},
           :status => :not_found
  end

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

  rescue_from StandardError do |exception|
    self.response_body = nil
    if exception.instance_of? ActiveRecord::RecordNotFound
      render :json => {:status => 404, :error => "Not Found"},
             :status => :not_found
    elsif Rails.env.production?
      render :json => {:status => 500, :error => "We're sorry, but something went wrong."},
             :status => :internal_server_error
    else
      raise exception
    end
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render :json => {:status => 400, :error => "Required parameter missing: #{exception.param}"},
           :status => :bad_request
  end

  private
  def authenticate_user_from_token!
    auth_token = request.headers['Authorization']

    if auth_token
      authenticate_with_auth_token auth_token
    else
      authentication_error
    end
  end

  def authenticate_with_auth_token(auth_token)
    unless auth_token.include?(':')
      authentication_error
      return
    end

    user_id = auth_token.split(':').first
    user = User.where(id: user_id).first

    if user && Devise.secure_compare(user.access_token, auth_token)
      sign_in user, store: false
    else
      authentication_error
    end
  end

  def authentication_error
    render json: { error: 'unauthorized' }, status: 401
  end
end
