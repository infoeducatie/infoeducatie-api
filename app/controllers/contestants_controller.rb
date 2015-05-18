class ContestantsController < ApplicationController
  before_filter :ensure_json_request
  before_action :set_contestant, only: [:show, :edit, :update, :destroy]

  # GET /contestants.json
  def index
    @contestants = Contestant.all
  end

  # GET /contestants/1.json
  def show
  end

  # POST /contestants.json
  def create
    @contestant = Contestant.new(contestant_params)

    respond_to do |format|
      if @contestant.save
        format.json { render :show, status: :created, location: @contestant }
      else
        format.json { render json: @contestant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contestants/1.json
  def update
    respond_to do |format|
      if @contestant.update(contestant_params)
        format.json { render :show, status: :ok, location: @contestant }
      else
        format.json { render json: @contestant.errors, status: :unprocessable_entity }
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
        :user_id,
        :edition_id,
        :accompanying_teacher_id
      )
    end
end
