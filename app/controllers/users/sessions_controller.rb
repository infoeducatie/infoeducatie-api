class Users::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token
  respond_to :html, :json
end
