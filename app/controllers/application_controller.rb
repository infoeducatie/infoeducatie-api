class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

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
end
