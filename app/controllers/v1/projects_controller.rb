module V1
  class ProjectsController < ApplicationController
    before_action :set_project, only: [:show, :edit, :update, :destroy]
    before_action :set_edition, only: [:index]
    before_action :authenticate_user_from_token!, only: [:create]

    respond_to :json

    # GET /v1/projects.json
    def index
      @projects = Project.where(edition_id: @edition.id).all
    end

    # GET /v1/projects/1.json
    def show
    end

    # POST /v1/project.json
    def create
      @project = current_user.projects.build(project_params)
      @project .edition = Edition.find_by(current: true)

      if @project.save
        render :show, status: :created
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_project
        @project = Project.find(params[:id])
      end

      def set_edition
        @edition = if params.has_key?(:edition)
          Edition.find(params[:edition])
        else
          Edition.find_by(current: true)
        end
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def project_params
        params.require(:project).permit(
        )
      end
  end
end
