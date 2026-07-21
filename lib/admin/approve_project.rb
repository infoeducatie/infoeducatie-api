module RailsAdmin
  module Config
    module Actions
      class ApproveProject < RailsAdmin::Config::Actions::Base

        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'fas fa-check'
        end

        register_instance_option :http_methods do
          %i[get post]
        end

        register_instance_option :controller do
          Proc.new do
            if request.get?
              render @action.template_name
            else
              discourse = Discourse.new
              topic_id = discourse.publish(
                object.discourse_title,
                object.discourse_content,
                object.edition.projects_forum_category,
                object.topic_id
              )

              raise Discourse::NotConfiguredError if topic_id.blank?

              @object.update!(
                status: Project::STATUS_APPROVED,
                topic_id: topic_id
              )

              flash[:success] = "You have approved the project titled: #{@object.title}."
              redirect_to index_path
            end
          rescue Discourse::NotConfiguredError, DiscourseApi::DiscourseError => error
            Rails.logger.error(
              "Project approval failed for project=#{@object.id}: " \
              "#{error.class}: #{error.message}"
            )
            flash[:error] = "The project could not be published to Discourse. No changes were made."
            redirect_to index_path
          end
        end

      end
    end
  end
end
