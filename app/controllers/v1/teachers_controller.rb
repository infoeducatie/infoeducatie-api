module V1
  class TeachersController < ApplicationController
    before_action :set_teacher, only: [:show]
    before_action :authenticate_user_from_token!, only: [:create]

    respond_to :json

    # GET /v1/teachers.json?email=XX
    def index
      edition = if params.has_key?(:edition)
        Edition.find_by(id: params[:edition])
      else
        Edition.get_current
      end

      @teachers = Teacher.joins(:user).where(edition: edition)
      @teachers = @teachers.where(users: { email: params[:email] }) if params[:email].present?
      @teachers = @teachers.all
    end

    # GET /v1/teachers/1.json
    def show
    end

    # POST /v1/teachers.json
    def create
      @teacher = current_user.teachers.build(teacher_params)
      @teacher.edition = Edition.get_current

      if @teacher.save
        render :show, status: :created
      else
        if @teacher.edition.nil?
          render json: { edition: [ "There is no edition marked as current" ] }, status: :unprocessable_entity
        else
          render json: @teacher.errors, status: :unprocessable_entity
        end
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_teacher
        @teacher = Teacher.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def teacher_params
        params.require(:teacher).permit(
          :sex,
          :phone_number,
          :school_name,
          :school_county,
          :school_city,
          :school_country
        )
      end
  end
end
