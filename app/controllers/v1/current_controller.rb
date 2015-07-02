module V1
  class CurrentController < ApplicationController

    respond_to :json

    # GET /v1/current
    def index
      total_counties = Project.active.joins(:contestants)
                              .count('county', :distinct => true)
      total_participants = Project.active.joins(:contestants)
                                  .count(:contestant_id)
      @current = {
        is_logged_in: false,
        :stats => {
          :total_projects => Project.active.size,
          :total_participants => total_participants,
          :total_counties => total_counties
        },
        :edition => Edition.current
      }

      unless current_user.nil?
        projects = current_user.current_contestant.projects

        @current = @current.merge({
          is_logged_in: true,
          user: current_user,
          registration: {
            has_contestant: !current_user.contestants.empty?,
            has_projects: !projects.empty?,
            projects: projects,
          }
        })
      end

      @current = RecursiveOpenStruct.new @current
    end
  end
end
