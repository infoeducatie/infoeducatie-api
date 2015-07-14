module V1
  class EditionsController < ApplicationController

    def index
      @editions = Edition.where(published: true).order(year: :asc)
                         .order(registration_start_date: :asc).all
    end

  end
end
