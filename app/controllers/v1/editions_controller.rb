module V1
  class EditionsController < ApplicationController

    def index
      @editions = Edition.published.order(year: :asc)
                         .order(registration_start_date: :asc)

      if params[:has_talks] == 'true'
        @editions = @editions.where("talks_count > 0")
      end

      if params[:has_results] == 'true'
        @editions = @editions.where(show_results: true)
      end

      @editions = @editions.all

      if params[:has_projects] == 'true'
        @editions.to_a.select! { |edition| edition.projects_count > 0 }
      end

      @editions
    end

  end
end
