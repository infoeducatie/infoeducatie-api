module V1
  class ContestantsController < ApplicationController
    before_action :set_contestant, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user_from_token!, only: [:create]

    respond_to :json

    # GET /v1/contestants.json?email=XXX
    def index
      editition_id = if params.has_key?(:edition)
        params[:editition]
      else
        Edition.find_by(current: true).id
      end

      @contestants = Contestant.where(
        edition_id: editition_id
      ).all
    end

    # GET /v1/contestants/1.json
    def show
    end

    # POST /v1/contestants/additional.json?project_id=XXX&user_id=XXX
    def additional
      contestant = Contestant.build(contestant_params.merge({
        user: User.find_by(id: params[:user_id]),
        edition: Edition.find_by(current: true),
        project: Project.find_by(id: params[:project_id])
      }))

      if @contestant.save
        render :show, status: :created
      else
        render json: @contestant.errors, status: :unprocessable_entity
      end
    end

    # POST /v1/contestants.json
    def create
      @contestant = current_user.contestants.build(contestant_params)
      @contestant.edition = Edition.find_by(current: true)

      if @contestant.save
        render :show, status: :created
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
          :sex,
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
