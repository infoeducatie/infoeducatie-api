module V1
  class CurrentController < ApplicationController
    before_action :authenticate_user_from_token!, only: [:index]

    respond_to :json

    # GET /v1/current
    def index
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
        edition: edition,
        stats: {
          total_projects: Project.active.size,
          total_participants: current_user.contestants.size,
          total_counties: total_counties
        }
      }

      render json: @current
    end
  end
end
