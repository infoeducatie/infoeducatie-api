require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminPinNews
end

module RailsAdmin
  module Config
    module Actions
      class PinNews < RailsAdmin::Config::Actions::Base

        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'icon-exclamation-sign'
        end

        register_instance_option :controller do
          Proc.new do
            News.update_all("pinned = 0")
            @object.reload
            @object.update_attribute(:pinned, true)
            flash[:notice] = "You have pinned the news titled: #{@object.title}."

            redirect_to back_or_index
          end
        end

      end
    end
  end
end
