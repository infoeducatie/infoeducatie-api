module V1
  class SessionsController < ApiController
    def create
      credentials = params.require(:user).permit(:email, :password)

      @user = User.find_for_database_authentication(email: credentials[:email])
      return invalid_login_attempt unless @user

      if @user.valid_password?(credentials[:password]) &&
         @user.active_for_authentication?
        sign_in :user, @user
        render json: {
          email: @user.email,
          token_type: "Bearer",
          user_id: @user.id,
          access_token: @user.access_token
        }
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
