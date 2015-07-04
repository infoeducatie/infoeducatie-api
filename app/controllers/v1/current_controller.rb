module V1
  class CurrentController < ApplicationController
    before_action :authenticate_user_from_token
    respond_to :json

    # GET /v1/current
    def index
      edition = Edition.get_current

      total_counties = Contestant.where(edition: edition)
                                 .joins(:projects).where("projects.approved": true)
                                 .group_by(&:county).count

      total_participants = Contestant.where(edition: edition)
                                     .joins(:projects).where("projects.approved": true)
                                     .distinct.count

      @current = {
        is_logged_in: false,
        :stats => {
          :total_projects => Project.active.size,
          :total_participants => total_participants,
          :total_counties => total_counties
        },
        :edition => Edition.get_current
      }

      unless current_user.nil?
        @current.merge!({
          is_logged_in: true,
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
