module V1
  class EditionsController < ApplicationController

    def index
      @editions = Edition.where(published: true).order(year: :asc)
                         .order(registration_start_date: :asc).all

      if params[:has_talks] == 'true'
        @editions.select! { |edition| edition.has_talks? }
      end

      @editions
    end

  end
end
