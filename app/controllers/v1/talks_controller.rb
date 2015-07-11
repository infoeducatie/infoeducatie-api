module V1
  class TalksController < ApplicationController

    def index
      edition = if params.has_key?(:id)
        Edition.find_by(id: params[:id])
      else
        Edition.get_current
      end

      @talks = Talk.where(edition: edition)
    end

  end
end
