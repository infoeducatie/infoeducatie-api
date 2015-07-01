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

      @current = {
        user: current_user,
        registration: {
          has_contestant: has_contestant,
          has_projects: has_projects,
          has_finished: has_finished
        },
        edition: edition
      }

      render json: @current
    end
  end
end
