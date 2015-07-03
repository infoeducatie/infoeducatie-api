module V1
  class ContestantsController < ApplicationController
    before_action :set_contestant, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user_from_token!, only: [:create, :update_registration_step_number]

    respond_to :json

    # GET /v1/contestants.json?email=XXX
    def index
      edition = if params.has_key?(:edition)
        Edition.find_by(id: params[:edition])
      else
        Edition.get_current
      end

      @contestants = Contestant.joins(:user).where(edition: edition)
      @contestants = @contestants.where(users: { email: params[:email] }) if params[:email].present?
      @contestants = @contestants.all
    end

    # GET /v1/contestants/1.json
    def show
    end

    # POST /v1/contestants/update_registration_step_number
    def update_registration_step_number
      current_user.update_attribute(:registration_step_number,
                                    params[:step_number])
      render :status => 202, :nothing => true
    end

    # POST /v1/contestants.json
    def create
      @contestant = current_user.contestants.build(contestant_params)
      @contestant.edition = Edition.get_current

      if @contestant.save
        current_user.increment_registration_step_number!
        render :show, status: :created
      else
        if @contestant.edition.nil?
          render json: { edition: [ "There is no edition marked as current" ] }, status: :unprocessable_entity
        else
          render json: @contestant.errors, status: :unprocessable_entity
        end
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
          :accompanying_teacher_first_name,
          :accompanying_teacher_last_name,
          :official,
          :present_in_camp,
          :paying_camp_accommodation
        )
      end
  end
end
