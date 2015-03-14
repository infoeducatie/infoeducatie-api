class TalksController < ApplicationController
  before_action :set_talk, only: [:show, :edit, :update, :destroy]

  # GET /talks
  # GET /talks.json
  def index
    @talks = Talk.all
  end

  # GET /talks/1
  # GET /talks/1.json
  def show
  end

  # GET /talks/new
  def new
    @talk = Talk.new
  end

  # GET /talks/1/edit
  def edit
  end

  # POST /talks
  # POST /talks.json
  def create
    @talk = Talk.new(talk_params)
    if @talk.save
      render :show, status: :created, location: @talk
    else
      render json: @talk.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /talks/1
  # PATCH/PUT /talks/1.json
  def update
    if @talk.update(talk_params)
      render :show, status: :ok, location: @talk
    else
      render json: @talk.errors, status: :unprocessable_entity
    end
  end

  # DELETE /talks/1
  # DELETE /talks/1.json
  def destroy
    @talk.destroy
      head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_talk
      @talk = Talk.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def talk_params
      params.require(:talk).permit(:title, :description, :scheduled_at, :duration, :location)
    end
end
