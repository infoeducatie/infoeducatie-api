module RailsAdmin
  module Config
    module Actions
      class PinNews < RailsAdmin::Config::Actions::Base

        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          'fas fa-thumbtack'
        end

        register_instance_option :http_methods do
          %i[get post]
        end

        register_instance_option :controller do
          Proc.new do
            if request.get?
              render @action.template_name
            else
              News.transaction do
                News.where.not(id: @object.id).update_all(pinned: false)
                @object.update!(pinned: true)
              end

              flash[:success] = "You have pinned the news titled: #{@object.title}."
              redirect_to index_path
            end
          end
        end

      end
    end
  end
end
