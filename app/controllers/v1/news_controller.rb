module V1
  class NewsController < ApplicationController
    respond_to :json

    # GET /v1/news.json
    def index
      edition = if params.has_key?(:edition)
        Edition.published.find_by(id: params[:edition])
      else
        Edition.get_current
      end

      @news = News.all.where(edition: edition).order(created_at: :desc)

      @news.map do |n|
        n.body = "" if n.short.length < 50
      end
    end

    # GET /v1/show/1.json
    def show
      @news = News.find(params[:id])
    end

  end
end
