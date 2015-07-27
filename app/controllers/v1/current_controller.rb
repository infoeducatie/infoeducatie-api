module V1
  class CurrentController < ApplicationController
    before_action :authenticate_user_from_token
    respond_to :json

    # GET /v1/current
    def index
      edition = Edition.get_current
      is_registration_open = false

      if edition.registration_start_date <= Time.now.utc and
         edition.registration_end_date >= Time.now.utc
        is_registration_open = true
      end

      @current = {
        is_logged_in: false,
        is_registration_open: is_registration_open,
        :edition => Edition.get_current
      }

      unless current_user.nil?
        @current.merge!({
          is_logged_in: true,
          is_teacher: current_user.teachers
                                  .find_by(edition: Edition.get_current)
                                  .present?,
          user: current_user
        })

        if !current_user.contestants.empty?
          projects = current_user.get_current_contestant.projects

          if !projects.empty?
            pending_project = projects.find_by(:finished => false)

            @current.merge!({
              registration: {
                pending_project: pending_project,
                finished_projects: projects.where(:finished => true),
              }
            })
          end
        end
      end

      @current = RecursiveOpenStruct.new @current
    end
  end
end
