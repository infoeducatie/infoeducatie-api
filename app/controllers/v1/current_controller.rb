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
        edition: Edition.get_current,
        last_edition_with_results: Edition.get_last_with_results
      }

      unless current_user.nil?
        @current[:is_logged_in] = true
        @current[:is_contestant] = current_user.get_current_contestant.present?
        @current[:is_teacher] = current_user.get_current_teacher.present?
        @current[:user] = current_user

        if current_user.get_current_contestant.present?
          projects = current_user.get_current_contestant.projects

          if !projects.empty?
            pending_project = projects.find_by(:finished => false)

            @current[:registration] = {
              pending_project: pending_project,
              finished_projects: projects.where(:finished => true),
            }

            @current[:registration] = RecursiveOpenStruct.new(@current[:registration])
          end
        end
      end

      @current = RecursiveOpenStruct.new @current
    end
  end
end
