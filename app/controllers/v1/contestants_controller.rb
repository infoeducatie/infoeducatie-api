module V1
  class ContestantsController < ApplicationController
    before_action :set_contestant, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user_from_token!

    # GET /v1/contestants.json
    def index
      @contestants = Contestant.all
    end

    # GET /v1/contestants/1.json
    def show
    end

    # POST /v1/contestants.json
    def create
      @contestant = Contestant.new(contestant_params)
      if @contestant.save
        render :show, status: :created, location: @contestant
      else
        render json: @contestant.errors, status: :unprocessable_entity
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_contestant
        @contestant = Contestant.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def contestant_params
        params.require(:contestant).permit(
          :address,
          :city,
          :county,
          :country,
          :zip_code,
          :cnp,
          :id_card_type,
          :id_card_number,
          :phone_number,
          :school_name,
          :grade,
          :school_county,
          :school_city,
          :school_country,
          :date_of_birth,
          :mentoring_teacher_first_name,
          :mentoring_teacher_last_name,
          :official,
          :present_in_camp,
          :paying_camp_accommodation
        )
      end
  end
end
