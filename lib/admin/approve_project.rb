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
            title = object.discourse_title
            raw = object.discourse_content
            category = object.edition.projects_forum_category
            topic_id = object.discourse_topic_id

            discourse = Discourse.new
            topic_id = discourse.publish(title, raw, category, topic_id)

            raise ArgumentError if topic_id.nil?

            @object.update_attributes(
              status: Project::STATUS_APPROVED,
              discourse_topic_id: topic_id
            )

            flash[:notice] = "You have approved the project titled: #{@object.title}."

            redirect_to back_or_index
          end
        end

      end
    end
  end
end
