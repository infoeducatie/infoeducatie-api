module RailsAdmin
  module Config
    module Actions
      class RejectProject < RailsAdmin::Config::Actions::Base

        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'icon-remove'
        end

        register_instance_option :controller do
          Proc.new do
            discourse = Discourse.new
            discourse.delete(object.topic_id)

            @object.update_attributes(
              status: Project::STATUS_REJECTED
            )

            flash[:notice] = "You have rejected the project titled: #{@object.title}."

            redirect_to back_or_index
          end
        end

      end
    end
  end
end
