require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminApproveProject
end

module RailsAdmin
  module Config
    module Actions
      class ApproveProject < RailsAdmin::Config::Actions::Base

        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'icon-check'
        end

        register_instance_option :controller do
          Proc.new do
            @object.update_attribute(:approved, true)
            flash[:notice] = "You have approved the project titled: #{@object.title}."

            redirect_to back_or_index
          end
        end

      end
    end
  end
end
