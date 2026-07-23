module RailsAdmin
  module Config
    module Actions
      class RevokeApiCredential < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          "fas fa-ban"
        end

        register_instance_option :http_methods do
          %i[get post]
        end

        register_instance_option :controller do
          proc do
            if request.get?
              render @action.template_name
            else
              @object.revoke!(by: current_user)
              Rails.logger.info(
                "API credential revoked credential_id=#{@object.id} " \
                "admin_user_id=#{current_user.id}"
              )
              flash[:success] = "The API key #{@object.name} has been revoked."
              redirect_to index_path
            end
          end
        end
      end
    end
  end
end
