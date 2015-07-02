require 'ostruct'

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
        :edition => Edition.find_by(current: true)
      }

      unless current_user.nil?
        projects = (current_user.contestants.map do |contestant|
          contestant.projects
        end).flatten

        @current = @current.merge({
          is_logged_in: true,
          user: current_user,
          registration: {
            has_contestant: !current_user.contestants.empty?,
            has_projects: projects.empty?,
            has_finished: projects.map(&:finished).any?
          }
        })
      end

      @current = OpenStruct.new @current
    end
  end
end
