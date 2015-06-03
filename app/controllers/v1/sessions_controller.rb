module V1
  class SessionsController < ApplicationController
    def create
      user = params[:user]

      @user = User.find_for_database_authentication(email: user[:email])
      return invalid_login_attempt unless @user

      if @user.valid_password?(user[:password])
        sign_in :user, @user
        render json: @user, serializer: SessionSerializer, root: nil
      else
        invalid_login_attempt
      end
    end

    private

    def invalid_login_attempt
      warden.custom_failure!
      render json: {
        error: "Invalid login attempt"
      }, status: :unprocessable_entity
    end
  end
end
