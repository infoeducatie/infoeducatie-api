module V1
  class EditionsController < ApplicationController

    def index
      @editions = Edition.where(published: true).order(year: :asc)
                         .order(registration_start_date: :asc)

      if params[:has_talks] == 'true'
        @editions.where("talks_count > 0")
      end

      if params[:has_results] == 'true'
        @editions.where(show_results: true)
      end

      if params[:has_contestants] == 'true'
        @editions.where("contestants_count > 0")
      end

      @editions.all
    end

  end
end
