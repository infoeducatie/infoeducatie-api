class SponsorsController < ApplicationController
  before_action :set_sponsor, only: [:show, :edit, :update, :destroy]

  # GET /sponsors
  # GET /sponsors.json
  def index
    @sponsors = Sponsor.all
  end

  # GET /sponsors/1
  # GET /sponsors/1.json
  def show
  end

  # GET /sponsors/new
  def new
    @sponsor = Sponsor.new
  end

  # GET /sponsors/1/edit
  def edit
  end

  # POST /sponsors
  # POST /sponsors.json
  def create
    @sponsor = Sponsor.new(sponsor_params)
    if @sponsor.save
      render :show, status: :created, location: @sponsor
    else
      render json: @sponsor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sponsors/1
  # PATCH/PUT /sponsors/1.json
  def update
    if @sponsor.update(sponsor_params)
      render :show, status: :ok, location: @sponsor
    else
      render json: @sponsor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sponsors/1
  # DELETE /sponsors/1.json
  def destroy
    @sponsor.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sponsor
      @sponsor = Sponsor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sponsor_params
      params.require(:sponsor).permit(:edition_id, :name, :logo)
    end
end
