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
        :edition => Edition.get_current
      }

      unless current_user.nil?
        @current.merge!({
          is_logged_in: true,
          user: current_user
        })

        registration = {
          has_contestant: false
        }

        if !current_user.contestants.empty?
          registration.merge!({
            has_contestant: true,
            has_projects: false
          })

          projects = current_user.current_contestant.projects

          if !projects.empty?
            has_pending_project = !projects.map(&:finished).all?
            pending_project_title = if has_pending_project
              projects.where(:finished => false).first.title
            else
              ""
            end

            registration.merge!({
              has_projects: true,
              has_pending_project: !projects.map(&:finished).all?,
              pending_project_title: pending_project_title,
              projects: projects,
            })
          end
        end

        @current.merge!({
          registration: registration
        })
      end

      @current = RecursiveOpenStruct.new @current
    end
  end
end
