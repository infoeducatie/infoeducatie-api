class ErrorsController < ApplicationController
  def error_500
    render :json => {:status => 500, :error => "We're sorry, but something went wrong"},
           :status => :internal_server_error
  end

  def error_404
    render :json => {:status => 404, :error => "Not Found"},
           :status => :not_found
  end

  def error_422
    render :json => {:status => 422, :error => "The change you wanted was rejected"},
           :status => :unprocessable_entity
  end
end
