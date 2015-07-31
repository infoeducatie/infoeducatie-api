module V1
  class TalksController < ApplicationController

    def index
      edition = if params.has_key?(:edition)
        Edition.published.find_by(id: params[:edition])
      else
        Edition.get_current
      end

      @talks = Talk.where(edition: edition)
    end

  end
end
