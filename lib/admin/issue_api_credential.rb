module RailsAdmin
  module Config
    module Actions
      class IssueApiCredential < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :collection do
          true
        end

        register_instance_option :link_icon do
          "fas fa-key"
        end

        register_instance_option :http_methods do
          %i[get post]
        end

        register_instance_option :controller do
          proc do
            @available_scopes = ApiCredential::AVAILABLE_SCOPES
            @api_credential = ApiCredential.new(
              expires_at: 90.days.from_now,
              scopes: []
            )

            if request.get?
              render @action.template_name
              next
            end

            permitted = params.require(:api_credential).permit(
              :name,
              :description,
              :expires_at,
              scopes: []
            )

            @api_credential, @plaintext_token = ApiCredential.issue!(
              permitted.to_h.symbolize_keys,
              created_by: current_user
            )

            response.headers["Cache-Control"] = "no-store, max-age=0"
            response.headers["Pragma"] = "no-cache"
            Rails.logger.info(
              "API credential issued credential_id=#{@api_credential.id} " \
              "admin_user_id=#{current_user.id}"
            )
            render "rails_admin/main/issue_api_credential_result"
          rescue ActiveRecord::RecordInvalid => error
            @api_credential = error.record
            response.status = :unprocessable_content
            render @action.template_name
          end
        end
      end
    end
  end
end
