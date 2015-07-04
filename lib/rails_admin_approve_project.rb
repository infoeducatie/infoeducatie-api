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
            discourse = PublishToDiscourse.new(object)
            discourse_topic = discourse.publish!

            raise ArgumentError if discourse_topic["topic_id"].nil?

            @object.update_attributes(
              approved: true, discourse_topic_id: discourse_topic["topic_id"]
            )

            flash[:notice] = "You have approved the project titled: #{@object.title}."

            redirect_to back_or_index
          end
        end

      end
    end
  end
end
