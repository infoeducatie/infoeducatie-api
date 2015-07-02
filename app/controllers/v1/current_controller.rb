module V1
  class CurrentController < ApplicationController

    respond_to :json

    # GET /v1/current
    def index
      total_counties = Project.active.joins(:contestants)
                              .count('county', :distinct => true)
      stats = {
        total_projects: Project.active.size,
        total_participants: Contestant.joins(:projects).where(:projects => { :approved => true }).size,
        total_counties: total_counties
      }

      unless current_user.nil?
        has_contestant = !current_user.contestants.empty?

        projects = (current_user.contestants.map do |contestant|
          contestant.projects
        end).flatten

        has_projects = projects.empty?
        has_finished = projects.map(&:finished).any?
        edition = Edition.find_by(current: true)
        total_counties = Project.active.joins(:contestants)
                                .count('county', :distinct => true)

        @current = {
          user: current_user,
          registration: {
            has_contestant: has_contestant,
            has_projects: has_projects,
            has_finished: has_finished
          },
          edition: edition
        }
      else
        @current = {}
      end
      @current[:stats] = stats

      render json: @current
    end
  end
end
