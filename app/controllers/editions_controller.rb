class EditionsController < ApplicationController
  before_action :set_edition, only: [:show, :edit, :update, :destroy]

  # GET /editions
  # GET /editions.json
  def index
    @editions = Edition.all
  end

  # GET /editions/1
  # GET /editions/1.json
  def show
  end

  # GET /editions/new
  def new
    @edition = Edition.new
  end

  # GET /editions/1/edit
  def edit
  end

  # POST /editions
  # POST /editions.json
  def create
    @edition = Edition.new(edition_params)
    if @edition.save
      render :show, status: :created, location: @edition
    else
      render json: @edition.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /editions/1
  # PATCH/PUT /editions/1.json
  def update
    if @edition.update(edition_params)
      render :show, status: :ok, location: @edition
    else
      render json: @edition.errors, status: :unprocessable_entity
    end
  end

  # DELETE /editions/1
  # DELETE /editions/1.json
  def destroy
    @edition.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edition
      @edition = Edition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def edition_params
      params.require(:edition).permit(:start, :end, :cardinal, :motto)
    end
end
