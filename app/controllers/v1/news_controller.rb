module V1
  class NewsController < ApplicationController
    respond_to :json

    # GET /v1/news.json
    def index
      @news = News.all
    end

    # GET /v1/show/1.json
    def show
      @news = News.find(params[:id])
    end

  end
end
