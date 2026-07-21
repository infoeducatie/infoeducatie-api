module RailsAdmin
  module Config
    module Actions
      class RejectProject < RailsAdmin::Config::Actions::Base

        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'fas fa-times'
        end

        register_instance_option :http_methods do
          %i[get post]
        end

        register_instance_option :controller do
          Proc.new do
            if request.get?
              render @action.template_name
            else
              Discourse.new.delete(object.topic_id)
              @object.update!(status: Project::STATUS_REJECTED)

              flash[:success] = "You have rejected the project titled: #{@object.title}."
              redirect_to index_path
            end
          rescue DiscourseApi::DiscourseError => error
            Rails.logger.error(
              "Project rejection failed for project=#{@object.id}: " \
              "#{error.class}: #{error.message}"
            )
            flash[:error] = "The Discourse topic could not be removed. No changes were made."
            redirect_to index_path
          end
        end

      end
    end
  end
end
