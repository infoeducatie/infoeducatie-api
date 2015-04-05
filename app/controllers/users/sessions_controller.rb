class Users::SessionsController < Devise::SessionsController
  before_action :always_request_json, only: [:create]
  skip_before_filter :verify_authenticity_token
  respond_to :html, :json
end
